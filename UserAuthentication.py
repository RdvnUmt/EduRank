from flask import Flask, request, jsonify, make_response
from flask_sqlalchemy import SQLAlchemy
from flask_restful import Api, Resource
from flask_jwt_extended import (
    JWTManager, create_access_token, create_refresh_token, jwt_required,
    get_jwt_identity, get_jwt
)
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import timedelta
from flask_cors import CORS  # CORS desteği eklendi

app = Flask(__name__)
CORS(app)  # CORS izinleri açıldı

# **Veritabanı ve JWT Ayarları**
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///users.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["JWT_SECRET_KEY"] = "super-secret-key"
app.config["JWT_ACCESS_TOKEN_EXPIRES"] = timedelta(minutes=30)  # Access token süresi
app.config["JWT_REFRESH_TOKEN_EXPIRES"] = timedelta(days=7)  # Refresh token süresi

db = SQLAlchemy(app)
api = Api(app)
jwt = JWTManager(app)

# **Kullanıcı Modeli**
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password_hash = db.Column(db.String(256), nullable=False)


# **Kullanıcı Kaydı**
class Register(Resource):
    def post(self):
        data = request.get_json()
        if not data.get("username") or not data.get("password"):
            return make_response(jsonify({"status": "error", "message": "Username and password required"}), 400)

        if User.query.filter_by(username=data["username"]).first():
            return make_response(jsonify({"status": "error", "message": "Username already exists"}), 400)

        hashed_password = generate_password_hash(data["password"])
        new_user = User(username=data["username"], password_hash=hashed_password)
        db.session.add(new_user)
        db.session.commit()

        return make_response(jsonify({"status": "success", "message": "User created successfully", "data": {"username": new_user.username}}), 201)

api.add_resource(Register, "/register")


# **Giriş Yapma ve Token Alma**
class Login(Resource):
    def post(self):
        data = request.get_json()
        user = User.query.filter_by(username=data.get("username")).first()

        if not user or not check_password_hash(user.password_hash, data.get("password")):
            return make_response(jsonify({"status": "error", "message": "Invalid username or password"}), 401)

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
            return make_response(jsonify({"status": "success", "username": current_user, "message": "Welcome to your profile!"}), 200)
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


# **Veritabanını oluştur**
if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(debug=True)
