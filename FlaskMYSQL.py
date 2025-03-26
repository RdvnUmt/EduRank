from flask import Flask, request, jsonify, make_response
from flask_sqlalchemy import SQLAlchemy
from flask_restful import Api, Resource
from flask_jwt_extended import (
    JWTManager, create_access_token, create_refresh_token, jwt_required,
    get_jwt_identity, get_jwt
)
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import timedelta
from flask_cors import CORS
import re

app = Flask(__name__)
CORS(app)

# **MySQL Veritabanı ve JWT Ayarları**
app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+pymysql://root:emre2004@localhost/edurank"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["JWT_SECRET_KEY"] = "super-secret-key"
app.config["JWT_ACCESS_TOKEN_EXPIRES"] = timedelta(minutes=30)
app.config["JWT_REFRESH_TOKEN_EXPIRES"] = timedelta(days=7)

db = SQLAlchemy(app)
api = Api(app)
jwt = JWTManager(app)

# **Kullanıcı Modeli - Dış veritabanı tablosu ile eşleştirme**
class User(db.Model):
    __tablename__ = 'users'
    
    username = db.Column(db.String(50), primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(256), nullable=False)
    
    
    total_score = db.Column(db.Float, default=0)
    total_time_spent = db.Column(db.Integer, default=0)
    

# **Kullanıcı Kaydı**
class Register(Resource):
    def post(self):
        data = request.get_json()
        username = data.get("username")
        email = data.get("email")
        password = data.get("password")
        
        if not username or not email or not password:
            return make_response(jsonify({"status": "error", "message": "User ID, email, and password required"}), 400)
        
        if not re.match(r"[^@\s]+@[^@\s]+\.[^@\s]+", email):
            return make_response(jsonify({"status": "error", "message": "Invalid email format"}), 400)
        
        if User.query.filter_by(username=username).first() or User.query.filter_by(email=email).first():
            return make_response(jsonify({"status": "error", "message": "User ID or email already exists"}), 400)
        
        hashed_password = generate_password_hash(password)
        new_user = User(username=username, email=email, password_hash=hashed_password)
        db.session.add(new_user)
        db.session.commit()

        return make_response(jsonify({"status": "success", "message": "User created successfully", "data": {"username": new_user.username, "email": new_user.email}}), 201)

api.add_resource(Register, "/register")

# **Giriş Yapma ve Token Alma**
class Login(Resource):
    def post(self):
        data = request.get_json()
        identifier = data.get("identifier")  # Kullanıcı ID veya e-posta ile giriş
        password = data.get("password")
        
        user = User.query.filter((User.username == identifier) | (User.email == identifier)).first()
        
        if not user or not check_password_hash(user.password_hash, password):
            return make_response(jsonify({"status": "error", "message": "Invalid user ID/email or password"}), 401)
        
        access_token = create_access_token(identity=user.username)
        refresh_token = create_refresh_token(identity=user.username)
        
        return make_response(jsonify({
            "status": "success",
            "access_token": access_token,
            "refresh_token": refresh_token
        }), 200)

api.add_resource(Login, "/login")

# **Profil Bilgisi Alma**
class Profile(Resource):
    @jwt_required()
    def get(self):
        try:
            current_user = get_jwt_identity()
            user = User.query.filter_by(username=current_user).first()
            if user:
                return make_response(jsonify({
                    "status": "success", 
                    "username": user.username, 
                    "email": user.email,
                    "total_score": user.total_score,
                    "total_time_spent": user.total_time_spent
                }), 200)
            return make_response(jsonify({"status": "error", "message": "User not found"}), 404)
        except Exception as e:
            return make_response(jsonify({"status": "error", "message": str(e)}), 500)

api.add_resource(Profile, "/profile")

class UpdateScore(Resource):
    @jwt_required()
    def post(self):
        # Get the data from the request
        data = request.get_json()
        new_score = data.get("new_score")

        if new_score is None:
            return make_response(jsonify({"status": "error", "message": "New score is required"}), 400)

        current_user = get_jwt_identity()
        user = User.query.filter_by(username=current_user).first()

        if not user:
            return make_response(jsonify({"status": "error", "message": "User not found"}), 404)

        # Update the total score
        user.total_score += new_score

        try:
            db.session.commit()
            return make_response(jsonify({
                "status": "success",
                "message": "Score updated successfully",
                "total_score": user.total_score
            }), 200)
        except Exception as e:
            db.session.rollback()
            return make_response(jsonify({"status": "error", "message": str(e)}), 500)


# Add the resource to the API
api.add_resource(UpdateScore, "/update_score")

class UpdateTimeSpent(Resource):
    @jwt_required()
    def post(self):
        # Get the data from the request
        data = request.get_json()
        new_time_spent = data.get("new_time_spent")

        if new_time_spent is None:
            return make_response(jsonify({"status": "error", "message": "New time spent is required"}), 400)

        current_user = get_jwt_identity()
        user = User.query.filter_by(username=current_user).first()

        if not user:
            return make_response(jsonify({"status": "error", "message": "User not found"}), 404)

        # Update the total time spent
        user.total_time_spent += new_time_spent

        try:
            db.session.commit()
            return make_response(jsonify({
                "status": "success",
                "message": "Time spent updated successfully",
                "total_time_spent": user.total_time_spent
            }), 200)
        except Exception as e:
            db.session.rollback()
            return make_response(jsonify({"status": "error", "message": str(e)}), 500)

# Add the resource to the API
api.add_resource(UpdateTimeSpent, "/update_time_spent")

# **Liderlik Tablosu**
class Leaderboard(Resource):
    def get(self):
        try:
            # Kullanıcıları toplam skora göre azalan sırayla alıyoruz
            leaderboard = User.query.order_by(User.total_score.desc()).all()

            # Her kullanıcı için gerekli bilgileri döndürüyoruz
            result = []
            for user in leaderboard:
                result.append({
                    "username": user.username,
                    "total_score": user.total_score
                })

            return make_response(jsonify({"status": "success", "leaderboard": result}), 200)

        except Exception as e:
            return make_response(jsonify({"status": "error", "message": str(e)}), 500)


api.add_resource(Leaderboard, "/leaderboard")

# **Liderlik Tablosu**
class Leaderboard2(Resource):
    def get(self):
        try:
            # Kullanıcıları harcadıkları toplam zamana göre azalan sırayla alıyoruz
            leaderboard = User.query.order_by(User.total_time_spent.desc()).all()

            # Her kullanıcı için gerekli bilgileri döndürüyoruz
            result = []
            for user in leaderboard:
                result.append({
                    "username": user.username,
                    "total_time_spent": user.total_time_spent
                })

            return make_response(jsonify({"status": "success", "leaderboard": result}), 200)

        except Exception as e:
            return make_response(jsonify({"status": "error", "message": str(e)}), 500)


api.add_resource(Leaderboard2, "/leaderboard2")

# **Token Yenileme (Refresh Token ile)**
class TokenRefresh(Resource):
    @jwt_required(refresh=True)
    def post(self):
        current_user = get_jwt_identity()
        new_token = create_access_token(identity=current_user, expires_delta=timedelta(minutes=30))
        return jsonify({"status": "success", "access_token": new_token})

api.add_resource(TokenRefresh, "/refresh")

# **Çıkış Yapma ve Token Kara Listeye Alma**
BLACKLIST = set()

class Logout(Resource):
    @jwt_required()
    def post(self):
        jti = get_jwt()["jti"]
        BLACKLIST.add(jti)
        return make_response(jsonify({"status": "success", "message": "Successfully logged out!"}), 200)

@jwt.token_in_blocklist_loader
def check_if_token_in_blacklist(jwt_header, jwt_payload):
    return jwt_payload["jti"] in BLACKLIST

api.add_resource(Logout, "/logout")

if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(host='0.0.0.0', port=5000, debug=True)