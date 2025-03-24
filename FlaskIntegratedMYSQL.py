from flask import Flask, request, jsonify, make_response
from flask_sqlalchemy import SQLAlchemy
from flask_restful import Api, Resource
from flask_migrate import Migrate
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

# *Veritabanı ve JWT Ayarları*
app.config[
    "SQLALCHEMY_DATABASE_URI"] = "mysql+pymysql://root:Efeutku2004*@localhost/edurank"  # Burada MySQL bağlantısını kuruyoruz
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["JWT_SECRET_KEY"] = "super-secret-key"
app.config["JWT_ACCESS_TOKEN_EXPIRES"] = timedelta(minutes=30)
app.config["JWT_REFRESH_TOKEN_EXPIRES"] = timedelta(days=7)

db = SQLAlchemy(app)
api = Api(app)
jwt = JWTManager(app)
migrate = Migrate(app, db)

class User(db.Model):
    _tablename_ = 'users'  # Tablo adı

    # Kullanıcı bilgileri
    username = db.Column(db.String(50), primary_key=True)  # username'ı başa alıyoruz
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(256), nullable=False)

    # Quiz 1
    quiz1_score = db.Column(db.Float, default=0)
    quiz1_time_spent = db.Column(db.Integer, default=0)

    # Quiz 2
    quiz2_score = db.Column(db.Float, default=0)
    quiz2_time_spent = db.Column(db.Integer, default=0)

    # Quiz 3
    quiz3_score = db.Column(db.Float, default=0)
    quiz3_time_spent = db.Column(db.Integer, default=0)

    # Quiz 4
    quiz4_score = db.Column(db.Float, default=0)
    quiz4_time_spent = db.Column(db.Integer, default=0)

    # Quiz 5
    quiz5_score = db.Column(db.Float, default=0)
    quiz5_time_spent = db.Column(db.Integer, default=0)

    # Quiz 6
    quiz6_score = db.Column(db.Float, default=0)
    quiz6_time_spent = db.Column(db.Integer, default=0)

    # Quiz 7
    quiz7_score = db.Column(db.Float, default=0)
    quiz7_time_spent = db.Column(db.Integer, default=0)

    # Quiz 8
    quiz8_score = db.Column(db.Float, default=0)
    quiz8_time_spent = db.Column(db.Integer, default=0)

    # Quiz 9
    quiz9_score = db.Column(db.Float, default=0)
    quiz9_time_spent = db.Column(db.Integer, default=0)

    # Quiz 10
    quiz10_score = db.Column(db.Float, default=0)
    quiz10_time_spent = db.Column(db.Integer, default=0)

    # Toplam skor ve toplam süre
    total_score = db.Column(db.Float, default=0)
    total_time_spent = db.Column(db.Integer, default=0)

    def _repr_(self):
        return f'<User {self.username}>'



# *Kullanıcı Kaydı*
class Register(Resource):
    def post(self):
        data = request.get_json()
        username = data.get("username")
        email = data.get("email")
        password = data.get("password")

        if not username or not email or not password:
            return make_response(jsonify({"status": "error", "message": "Username, email, and password required"}), 400)

        if not re.match(r"[^@\s]+@[^@\s]+\.[^@\s]+", email):
            return make_response(jsonify({"status": "error", "message": "Invalid email format"}), 400)

        if User.query.filter_by(username=username).first() or User.query.filter_by(email=email).first():
            return make_response(jsonify({"status": "error", "message": "Username or email already exists"}), 400)

        hashed_password = generate_password_hash(password)
        new_user = User(username=username, email=email, password_hash=hashed_password)
        db.session.add(new_user)
        db.session.commit()

        return make_response(jsonify({"status": "success", "message": "User created successfully",
                                      "data": {"username": new_user.username, "email": new_user.email}}), 201)


api.add_resource(Register, "/register")


# *Giriş Yapma ve Token Alma*
class Login(Resource):
    def post(self):
        data = request.get_json()
        identifier = data.get("identifier")  # Kullanıcı adı veya e-posta ile giriş
        password = data.get("password")

        user = User.query.filter((User.username == identifier) | (User.email == identifier)).first()

        if not user or not check_password_hash(user.password_hash, password):
            return make_response(jsonify({"status": "error", "message": "Invalid username/email or password"}), 401)

        access_token = create_access_token(identity=user.username)
        refresh_token = create_refresh_token(identity=user.username)

        return make_response(jsonify({
            "status": "success",
            "access_token": access_token,
            "refresh_token": refresh_token
        }), 200)


api.add_resource(Login, "/login")


# *Profil Bilgisi Alma*
class Profile(Resource):
    @jwt_required()
    def get(self):
        try:
            current_user = get_jwt_identity()
            user = User.query.filter_by(username=current_user).first()
            if user:
                return make_response(jsonify({"status": "success", "username": user.username, "email": user.email}),
                                     200)
            return make_response(jsonify({"status": "error", "message": "User not found"}), 404)
        except Exception as e:
            return make_response(jsonify({"status": "error", "message": str(e)}), 500)


api.add_resource(Profile, "/profile")


# *Token Yenileme (Refresh Token ile)*
class TokenRefresh(Resource):
    @jwt_required(refresh=True)
    def post(self):
        current_user = get_jwt_identity()
        new_token = create_access_token(identity=current_user, expires_delta=timedelta(minutes=30))
        return jsonify({"status": "success", "access_token": new_token})


api.add_resource(TokenRefresh, "/refresh")

# *Çıkış Yapma ve Token Kara Listeye Alma*
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

# *Veritabanını oluştur*
if __name__ == "__main__":
    app.run(debug=True)