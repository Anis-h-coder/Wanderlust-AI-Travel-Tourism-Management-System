from flask import Blueprint, render_template, request, jsonify, session
from models.db import query_db
import requests
import json

ai_bp = Blueprint('ai', __name__, url_prefix='/ai')

# ── API credentials hardcoded directly ──────────

def call_groq(messages, system_prompt="You are a helpful travel assistant."):
    """Call Groq API — OpenAI-compatible endpoint."""
    headers = {
        "Authorization": f"Bearer {GROQ_API_KEY}",
        "Content-Type": "application/json"
    }
    payload = {
        "model": "llama-3.3-70b-versatile",
        "messages": [{"role": "system", "content": system_prompt}] + messages,
        "max_tokens": 1500,
        "temperature": 0.7
    }
    try:
        response = requests.post(
            GROQ_API_URL,
            headers=headers,
            json=payload,
            timeout=30
        )
        response.raise_for_status()
        data = response.json()
        return data['choices'][0]['message']['content']
    except requests.exceptions.HTTPError as e:
        return f"API Error: {response.status_code} — {response.text}"
    except Exception as e:
        return f"Sorry, I'm having trouble right now. Please try again. ({str(e)})"


# ── Chatbot ──────────────────────────────────────────────
@ai_bp.route('/chatbot')
def chatbot():
    return render_template('ai/chatbot.html')


@ai_bp.route('/chatbot/send', methods=['POST'])
def chatbot_send():
    data = request.get_json()
    user_message = data.get('message', '').strip()
    history = data.get('history', [])

    if not user_message:
        return jsonify({'error': 'Empty message'}), 400

    system_prompt = """You are TravelBot, an expert AI travel assistant for an Indian travel agency.
    Help users with travel queries, destination recommendations, visa info, packing tips,
    best time to visit, local customs, food, and budget planning. Be friendly, concise, and helpful.
    Focus primarily on Indian destinations but help with international queries too."""

    messages = history[-6:] + [{"role": "user", "content": user_message}]
    bot_reply = call_groq(messages, system_prompt)

    # Save to DB
    user_id = session.get('user_id')
    query_db(
        'INSERT INTO chat_history (user_id, user_message, bot_response) VALUES (%s, %s, %s)',
        (user_id, user_message, bot_reply), commit=True
    )

    return jsonify({'reply': bot_reply})


# ── Itinerary Generator ───────────────────────────────────
@ai_bp.route('/itinerary')
def itinerary():
    return render_template('ai/itinerary.html')


@ai_bp.route('/itinerary/generate', methods=['POST'])
def generate_itinerary():
    data = request.get_json()
    destination = data.get('destination', '')
    num_days = data.get('num_days', 3)
    interests = data.get('interests', 'sightseeing')
    budget = data.get('budget', 'moderate')

    system_prompt = """You are an expert travel itinerary planner. Create detailed, practical,
    day-wise travel itineraries. Format your response with clear Day 1, Day 2 etc. headings.
    Include morning, afternoon, and evening activities. Add practical tips, best restaurants,
    accommodation suggestions, and estimated costs where relevant."""

    prompt = f"""Create a detailed {num_days}-day travel itinerary for {destination}.
Interests: {interests}
Budget level: {budget}

Please provide:
- Day-wise plan (Morning, Afternoon, Evening for each day)
- Top attractions to visit
- Local food recommendations
- Travel tips
- Estimated daily budget in INR"""

    result = call_groq([{"role": "user", "content": prompt}], system_prompt)

    # Save if logged in
    user_id = session.get('user_id')
    if user_id:
        query_db(
            'INSERT INTO itineraries (user_id, destination, num_days, itinerary_text) VALUES (%s,%s,%s,%s)',
            (user_id, destination, num_days, result), commit=True
        )

    return jsonify({'itinerary': result})


# ── Recommendation System ─────────────────────────────────
@ai_bp.route('/recommendations')
def recommendations():
    return render_template('ai/recommendations.html')


@ai_bp.route('/recommendations/get', methods=['POST'])
def get_recommendations():
    data = request.get_json()
    budget = data.get('budget', '')
    location_pref = data.get('location_pref', '')
    travel_type = data.get('travel_type', '')
    duration = data.get('duration', '')
    group_type = data.get('group_type', '')

    system_prompt = """You are a travel recommendation expert specializing in Indian tourism.
    Always respond with ONLY a valid JSON array, no extra text, no markdown, no explanation."""

    prompt = f"""Recommend 4 travel destinations based on:
- Budget: ₹{budget} per person
- Preferred region: {location_pref}
- Travel type: {travel_type}
- Duration: {duration} days
- Group: {group_type}

Return ONLY a JSON array like this (no other text):
[
  {{
    "destination": "Place Name",
    "state": "State Name",
    "why_recommend": "2-3 sentence reason",
    "best_time": "Month range",
    "estimated_cost": "₹X,XXX - ₹X,XXX",
    "highlight": "One special highlight",
    "difficulty_level": "Easy/Moderate/Challenging"
  }}
]"""

    result = call_groq([{"role": "user", "content": prompt}], system_prompt)

    try:
        clean = result.strip()
        if '```' in clean:
            parts = clean.split('```')
            for part in parts:
                part = part.strip()
                if part.startswith('json'):
                    part = part[4:].strip()
                if part.startswith('['):
                    clean = part
                    break
        start = clean.find('[')
        end = clean.rfind(']')
        if start != -1 and end != -1:
            clean = clean[start:end+1]
        recommendations_data = json.loads(clean)
    except Exception as e:
        recommendations_data = []

    return jsonify({'recommendations': recommendations_data, 'raw': result})