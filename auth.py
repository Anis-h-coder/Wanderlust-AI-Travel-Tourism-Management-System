from flask import Blueprint, render_template, request, redirect, url_for, session, flash
import bcrypt
from models.db import query_db

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        full_name = request.form.get('full_name', '').strip()
        email = request.form.get('email', '').strip()
        password = request.form.get('password', '')
        phone = request.form.get('phone', '').strip()

        if not all([full_name, email, password]):
            flash('All fields are required.', 'error')
            return render_template('auth/register.html')

        existing = query_db('SELECT id FROM users WHERE email=%s', (email,), one=True)
        if existing:
            flash('Email already registered. Please login.', 'error')
            return render_template('auth/register.html')

        hashed = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        query_db(
            'INSERT INTO users (full_name, email, password_hash, phone) VALUES (%s, %s, %s, %s)',
            (full_name, email, hashed, phone), commit=True
        )
        flash('Registration successful! Please login.', 'success')
        return redirect(url_for('auth.login'))

    return render_template('auth/register.html')


@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email', '').strip()
        password = request.form.get('password', '')

        user = query_db('SELECT * FROM users WHERE email=%s', (email,), one=True)
        if user and bcrypt.checkpw(password.encode('utf-8'), user['password_hash'].encode('utf-8')):
            session.permanent = True
            session['user_id'] = user['id']
            session['user_name'] = user['full_name']
            session['user_email'] = user['email']
            session['user_role'] = user['role']
            flash(f"Welcome back, {user['full_name']}!", 'success')
            if user['role'] == 'admin':
                return redirect(url_for('admin.dashboard'))
            return redirect(url_for('main.index'))
        else:
            flash('Invalid email or password.', 'error')

    return render_template('auth/login.html')


@auth_bp.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out.', 'info')
    return redirect(url_for('main.index'))