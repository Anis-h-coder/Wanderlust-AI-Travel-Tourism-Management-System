from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from models.db import query_db
from functools import wraps

admin_bp = Blueprint('admin', __name__, url_prefix='/admin')

def admin_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if session.get('user_role') != 'admin':
            flash('Admin access required.', 'error')
            return redirect(url_for('auth.login'))
        return f(*args, **kwargs)
    return decorated


@admin_bp.route('/')
@admin_required
def dashboard():
    total_users = query_db('SELECT COUNT(*) as c FROM users WHERE role="user"', one=True)['c']
    total_packages = query_db('SELECT COUNT(*) as c FROM packages', one=True)['c']
    total_bookings = query_db('SELECT COUNT(*) as c FROM bookings', one=True)['c']
    revenue = query_db('SELECT SUM(total_price) as r FROM bookings WHERE status="confirmed"', one=True)['r'] or 0
    recent_bookings = query_db(
        '''SELECT b.*, u.full_name, u.email, p.title 
           FROM bookings b JOIN users u ON b.user_id=u.id JOIN packages p ON b.package_id=p.id
           ORDER BY b.booked_at DESC LIMIT 10'''
    )
    return render_template('admin/dashboard.html',
        total_users=total_users, total_packages=total_packages,
        total_bookings=total_bookings, revenue=revenue,
        recent_bookings=recent_bookings)


@admin_bp.route('/packages')
@admin_required
def packages():
    pkgs = query_db('SELECT * FROM packages ORDER BY created_at DESC')
    return render_template('admin/packages.html', packages=pkgs)


@admin_bp.route('/packages/add', methods=['GET', 'POST'])
@admin_required
def add_package():
    if request.method == 'POST':
        data = request.form
        query_db(
            '''INSERT INTO packages (title, destination, description, duration_days, price, max_people, image_url, category)
               VALUES (%s, %s, %s, %s, %s, %s, %s, %s)''',
            (data['title'], data['destination'], data['description'],
             data['duration_days'], data['price'], data['max_people'],
             data['image_url'], data['category']),
            commit=True
        )
        flash('Package added successfully!', 'success')
        return redirect(url_for('admin.packages'))
    return render_template('admin/add_package.html')


@admin_bp.route('/packages/edit/<int:pkg_id>', methods=['GET', 'POST'])
@admin_required
def edit_package(pkg_id):
    pkg = query_db('SELECT * FROM packages WHERE id=%s', (pkg_id,), one=True)
    if request.method == 'POST':
        data = request.form
        query_db(
            '''UPDATE packages SET title=%s, destination=%s, description=%s,
               duration_days=%s, price=%s, max_people=%s, image_url=%s, category=%s
               WHERE id=%s''',
            (data['title'], data['destination'], data['description'],
             data['duration_days'], data['price'], data['max_people'],
             data['image_url'], data['category'], pkg_id),
            commit=True
        )
        flash('Package updated!', 'success')
        return redirect(url_for('admin.packages'))
    return render_template('admin/add_package.html', package=pkg)


@admin_bp.route('/packages/delete/<int:pkg_id>', methods=['POST'])
@admin_required
def delete_package(pkg_id):
    query_db('UPDATE packages SET is_active=0 WHERE id=%s', (pkg_id,), commit=True)
    flash('Package deleted.', 'info')
    return redirect(url_for('admin.packages'))


@admin_bp.route('/bookings')
@admin_required
def bookings():
    all_bookings = query_db(
        '''SELECT b.*, u.full_name, u.email, p.title, p.destination
           FROM bookings b JOIN users u ON b.user_id=u.id JOIN packages p ON b.package_id=p.id
           ORDER BY b.booked_at DESC'''
    )
    return render_template('admin/bookings.html', bookings=all_bookings)


@admin_bp.route('/bookings/update/<int:bid>', methods=['POST'])
@admin_required
def update_booking(bid):
    status = request.form.get('status')
    query_db('UPDATE bookings SET status=%s WHERE id=%s', (status, bid), commit=True)
    flash('Booking status updated.', 'success')
    return redirect(url_for('admin.bookings'))