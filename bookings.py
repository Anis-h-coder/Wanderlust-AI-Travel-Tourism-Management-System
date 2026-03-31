from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from models.db import query_db
from functools import wraps

bookings_bp = Blueprint('bookings', __name__)

def login_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please login to continue.', 'warning')
            return redirect(url_for('auth.login'))
        return f(*args, **kwargs)
    return decorated


@bookings_bp.route('/book/<int:pkg_id>', methods=['GET', 'POST'])
@login_required
def book_package(pkg_id):
    pkg = query_db('SELECT * FROM packages WHERE id=%s AND is_active=1', (pkg_id,), one=True)
    if not pkg:
        flash('Package not found.', 'error')
        return redirect(url_for('packages.list_packages'))

    if request.method == 'POST':
        travel_date = request.form.get('travel_date')
        num_people = int(request.form.get('num_people', 1))
        special_requests = request.form.get('special_requests', '')
        total_price = pkg['price'] * num_people

        booking_id = query_db(
            '''INSERT INTO bookings (user_id, package_id, travel_date, num_people, total_price, special_requests)
               VALUES (%s, %s, %s, %s, %s, %s)''',
            (session['user_id'], pkg_id, travel_date, num_people, total_price, special_requests),
            commit=True
        )
        flash('Booking confirmed successfully!', 'success')
        return redirect(url_for('bookings.confirmation', booking_id=booking_id))

    return render_template('bookings/book.html', package=pkg)


@bookings_bp.route('/booking/confirmation/<int:booking_id>')
@login_required
def confirmation(booking_id):
    booking = query_db(
        '''SELECT b.*, p.title, p.destination, p.image_url, u.full_name, u.email
           FROM bookings b
           JOIN packages p ON b.package_id = p.id
           JOIN users u ON b.user_id = u.id
           WHERE b.id=%s AND b.user_id=%s''',
        (booking_id, session['user_id']), one=True
    )
    if not booking:
        flash('Booking not found.', 'error')
        return redirect(url_for('main.index'))
    return render_template('bookings/confirmation.html', booking=booking)


@bookings_bp.route('/dashboard')
@login_required
def user_dashboard():
    bookings = query_db(
        '''SELECT b.*, p.title, p.destination, p.image_url, p.duration_days
           FROM bookings b
           JOIN packages p ON b.package_id = p.id
           WHERE b.user_id=%s ORDER BY b.booked_at DESC''',
        (session['user_id'],)
    )
    user = query_db('SELECT * FROM users WHERE id=%s', (session['user_id'],), one=True)
    return render_template('dashboard/user.html', bookings=bookings, user=user)


@bookings_bp.route('/booking/cancel/<int:booking_id>', methods=['POST'])
@login_required
def cancel_booking(booking_id):
    query_db(
        'UPDATE bookings SET status="cancelled" WHERE id=%s AND user_id=%s',
        (booking_id, session['user_id']), commit=True
    )
    flash('Booking cancelled.', 'info')
    return redirect(url_for('bookings.user_dashboard'))