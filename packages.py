from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from models.db import query_db

packages_bp = Blueprint('packages', __name__)

@packages_bp.route('/packages')
def list_packages():
    category = request.args.get('category', '')
    search = request.args.get('search', '')
    
    if category and search:
        pkgs = query_db(
            'SELECT * FROM packages WHERE is_active=1 AND category=%s AND (title LIKE %s OR destination LIKE %s)',
            (category, f'%{search}%', f'%{search}%')
        )
    elif category:
        pkgs = query_db('SELECT * FROM packages WHERE is_active=1 AND category=%s', (category,))
    elif search:
        pkgs = query_db(
            'SELECT * FROM packages WHERE is_active=1 AND (title LIKE %s OR destination LIKE %s)',
            (f'%{search}%', f'%{search}%')
        )
    else:
        pkgs = query_db('SELECT * FROM packages WHERE is_active=1 ORDER BY rating DESC')
    
    return render_template('packages/list.html', packages=pkgs, category=category, search=search)


@packages_bp.route('/packages/<int:pkg_id>')
def package_detail(pkg_id):
    pkg = query_db('SELECT * FROM packages WHERE id=%s AND is_active=1', (pkg_id,), one=True)
    if not pkg:
        flash('Package not found.', 'error')
        return redirect(url_for('packages.list_packages'))
    return render_template('packages/detail.html', package=pkg)