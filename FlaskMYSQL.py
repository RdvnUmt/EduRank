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
app.config["SQLALCHEMY_DATABASE_URI"] = "mysql://kullanici_adi:sifre@localhost/quiz_db"
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
    
    user_id = db.Column(db.String(50), primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(256), nullable=False)
    
    # Quiz skorları ve süreleri - Var olan MySQL tablosuna uyumlu
    quiz1_score = db.Column(db.Float, default=0)
    quiz1_time_spent = db.Column(db.Integer, default=0)
    quiz2_score = db.Column(db.Float, default=0)
    quiz2_time_spent = db.Column(db.Integer, default=0)
    quiz3_score = db.Column(db.Float, default=0)
    quiz3_time_spent = db.Column(db.Integer, default=0)
    quiz4_score = db.Column(db.Float, default=0)
    quiz4_time_spent = db.Column(db.Integer, default=0)
    quiz5_score = db.Column(db.Float, default=0)
    quiz5_time_spent = db.Column(db.Integer, default=0)
    quiz6_score = db.Column(db.Float, default=0)
    quiz6_time_spent = db.Column(db.Integer, default=0)
    quiz7_score = db.Column(db.Float, default=0)
    quiz7_time_spent = db.Column(db.Integer, default=0)
    quiz8_score = db.Column(db.Float, default=0)
    quiz8_time_spent = db.Column(db.Integer, default=0)
    quiz9_score = db.Column(db.Float, default=0)
    quiz9_time_spent = db.Column(db.Integer, default=0)
    quiz10_score = db.Column(db.Float, default=0)
    quiz10_time_spent = db.Column(db.Integer, default=0)
    
    total_score = db.Column(db.Float, default=0)
    total_time_spent = db.Column(db.Integer, default=0)
    
    def update_total_stats(self):
        # Tüm quiz skorlarını al
        scores = [
            self.quiz1_score, self.quiz2_score, self.quiz3_score, self.quiz4_score, self.quiz5_score,
            self.quiz6_score, self.quiz7_score, self.quiz8_score, self.quiz9_score, self.quiz10_score
        ]
        
        # Tüm quiz sürelerini al
        times = [
            self.quiz1_time_spent, self.quiz2_time_spent, self.quiz3_time_spent, 
            self.quiz4_time_spent, self.quiz5_time_spent, self.quiz6_time_spent,
            self.quiz7_time_spent, self.quiz8_time_spent, self.quiz9_time_spent, 
            self.quiz10_time_spent
        ]
        
        # En az bir quiz çözülmüşse ortalamaları hesapla
        completed_quizzes = sum(1 for score in scores if score > 0)
        
        if completed_quizzes > 0:
            self.total_score = sum(scores) / completed_quizzes
        else:
            self.total_score = 0
            
        self.total_time_spent = sum(times)
        db.session.commit()

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

        return make_response(jsonify({"status": "success", "message": "User created successfully", "data": {"user_id": new_user.user_id, "email": new_user.email}}), 201)

api.add_resource(Register, "/register")

# **Giriş Yapma ve Token Alma**
class Login(Resource):
    def post(self):
        data = request.get_json()
        identifier = data.get("identifier")  # Kullanıcı ID veya e-posta ile giriş
        password = data.get("password")
        
        user = User.query.filter((User.user_id == identifier) | (User.email == identifier)).first()
        
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

# **Quiz Skorlarını Güncelleme**
class QuizScore(Resource):
    @jwt_required()
    def post(self, quiz_number):
        if not 1 <= quiz_number <= 10:
            return make_response(jsonify({"status": "error", "message": "Invalid quiz number"}), 400)
        
        try:
            current_user = get_jwt_identity()
            user = User.query.filter_by(user_id=current_user).first()
            
            if not user:
                return make_response(jsonify({"status": "error", "message": "User not found"}), 404)
            
            data = request.get_json()
            score = data.get("score", 0)
            time_spent = data.get("time_spent", 0)
            
            # İlgili quiz skorunu ve süresini güncelle
            setattr(user, f"quiz{quiz_number}_score", score)
            setattr(user, f"quiz{quiz_number}_time_spent", time_spent)
            
            # Toplam istatistikleri güncelle
            user.update_total_stats()
            
            return make_response(jsonify({
                "status": "success", 
                "message": f"Quiz {quiz_number} score updated",
                "score": score,
                "time_spent": time_spent,
                "total_score": user.total_score,
                "total_time_spent": user.total_time_spent
            }), 200)
        except Exception as e:
            return make_response(jsonify({"status": "error", "message": str(e)}), 500)

api.add_resource(QuizScore, "/quiz/<int:quiz_number>/score")

# **Tüm Quiz Skorlarını Getirme**
class AllQuizScores(Resource):
    @jwt_required()
    def get(self):
        try:
            current_user = get_jwt_identity()
            user = User.query.filter_by(user_id=current_user).first()
            
            if not user:
                return make_response(jsonify({"status": "error", "message": "User not found"}), 404)
            
            scores = {}
            for i in range(1, 11):
                scores[f"quiz{i}"] = {
                    "score": getattr(user, f"quiz{i}_score"),
                    "time_spent": getattr(user, f"quiz{i}_time_spent")
                }
            
            return make_response(jsonify({
                "status": "success",
                "user_id": user.user_id,
                "quizzes": scores,
                "total_score": user.total_score,
                "total_time_spent": user.total_time_spent
            }), 200)
        except Exception as e:
            return make_response(jsonify({"status": "error", "message": str(e)}), 500)

api.add_resource(AllQuizScores, "/quiz/scores")

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