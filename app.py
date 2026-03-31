from flask import Flask, render_template, session
from config import Config
from routes.auth import auth_bp
from routes.packages import packages_bp
from routes.bookings import bookings_bp
from routes.admin import admin_bp
from routes.ai_features import ai_bp
from flask import Blueprint

app = Flask(__name__)
app.config.from_object(Config)
app.secret_key = Config.SECRET_KEY

# Register Blueprints
app.register_blueprint(auth_bp)
app.register_blueprint(packages_bp)
app.register_blueprint(bookings_bp)
app.register_blueprint(admin_bp)
app.register_blueprint(ai_bp)

# Main blueprint for home
main_bp = Blueprint('main', __name__)

@main_bp.route('/')
def index():
    from models.db import query_db
    featured = query_db('SELECT * FROM packages WHERE is_active=1 ORDER BY rating DESC LIMIT 6')
    return render_template('index.html', packages=featured)

app.register_blueprint(main_bp)

@app.errorhandler(404)
def not_found(e):
    return render_template('404.html'), 404

@app.context_processor
def inject_user():
    return dict(
        logged_in='user_id' in session,
        current_user_name=session.get('user_name', ''),
        current_user_role=session.get('user_role', 'user')
    )

if __name__ == '__main__':
    app.run(debug=True, port=5000)