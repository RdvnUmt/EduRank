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
app.config["SQLALCHEMY_DATABASE_URI"] = "mysql://root:emre2004@localhost/edurank"
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
        user_id = data.get("user_id")
        email = data.get("email")
        password = data.get("password")
        
        if not user_id or not email or not password:
            return make_response(jsonify({"status": "error", "message": "User ID, email, and password required"}), 400)
        
        if not re.match(r"[^@\s]+@[^@\s]+\.[^@\s]+", email):
            return make_response(jsonify({"status": "error", "message": "Invalid email format"}), 400)
        
        if User.query.filter_by(user_id=user_id).first() or User.query.filter_by(email=email).first():
            return make_response(jsonify({"status": "error", "message": "User ID or email already exists"}), 400)
        
        hashed_password = generate_password_hash(password)
        new_user = User(user_id=user_id, email=email, password_hash=hashed_password)
        db.session.add(new_user)
        db.session.commit()

        return make_response(jsonify({"status": "success", "message": "User created successfully", "data": {"user_id": new_user.username, "email": new_user.email}}), 201)

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
        
        access_token = create_access_token(identity=user.user_id)
        refresh_token = create_refresh_token(identity=user.user_id)
        
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
            user = User.query.filter_by(user_id=current_user).first()
            if user:
                return make_response(jsonify({
                    "status": "success", 
                    "user_id": user.user_id, 
                    "email": user.email,
                    "total_score": user.total_score,
                    "total_time_spent": user.total_time_spent
                }), 200)
            return make_response(jsonify({"status": "error", "message": "User not found"}), 404)
        except Exception as e:
            return make_response(jsonify({"status": "error", "message": str(e)}), 500)

api.add_resource(Profile, "/profile")



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
    app.run(debug=True)