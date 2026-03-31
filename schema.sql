-- AI-Based Travel & Tourism Management System
-- MySQL Database Schema

CREATE DATABASE IF NOT EXISTS travel_management;
USE travel_management;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('user', 'admin') DEFAULT 'user',
    profile_pic VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Packages Table
CREATE TABLE IF NOT EXISTS packages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    destination VARCHAR(150) NOT NULL,
    description TEXT,
    duration_days INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    max_people INT DEFAULT 10,
    image_url VARCHAR(500),
    category ENUM('adventure', 'beach', 'cultural', 'wildlife', 'luxury', 'budget') DEFAULT 'cultural',
    rating DECIMAL(3,1) DEFAULT 4.0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bookings Table
CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    package_id INT NOT NULL,
    travel_date DATE NOT NULL,
    num_people INT NOT NULL DEFAULT 1,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled') DEFAULT 'pending',
    special_requests TEXT,
    booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (package_id) REFERENCES packages(id) ON DELETE CASCADE
);

-- Saved Itineraries Table
CREATE TABLE IF NOT EXISTS itineraries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    destination VARCHAR(150),
    num_days INT,
    itinerary_text LONGTEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Chat History Table
CREATE TABLE IF NOT EXISTS chat_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    user_message TEXT,
    bot_response TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Sample Admin User (password: admin123 - bcrypt hash)
INSERT INTO users (full_name, email, password_hash, role) VALUES 
('Admin User', 'admin@travel.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J7qZqQK1u', 'admin');

-- ═══════════════════════════════════════════════
-- 60 PACKAGES — 10 per category
-- ═══════════════════════════════════════════════
INSERT INTO packages (title, destination, description, duration_days, price, max_people, image_url, category, rating) VALUES
-- ═══════════════════════════════════════════════
-- ADVENTURE (10)
-- ═══════════════════════════════════════════════
('Manali Snow Adventure', 'Manali, Himachal Pradesh', 'Experience thrilling snow activities, trekking through alpine meadows, and the breathtaking Rohtang Pass. Enjoy skiing, snowboarding, and river rafting in the Beas river surrounded by towering Himalayan peaks.', 5, 15000.00, 18, 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=800', 'adventure', 4.7),
('Ladakh High Altitude Trek', 'Leh, Ladakh', 'Embark on an epic journey through the world''s highest motorable passes, ancient monasteries, and stark lunar landscapes. Visit the stunning Pangong Lake, Nubra Valley, and ancient Thiksey Monastery.', 9, 40000.00, 8, 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800', 'adventure', 4.8),
('Rishikesh River Rafting & Camping', 'Rishikesh, Uttarakhand', 'Conquer the mighty Ganges with Grade 3-4 rapids, bungee jumping from 83 meters, cliff jumping, camping under stars, and yoga sessions at sunrise. The undisputed adventure capital of India awaits.', 4, 12000.00, 20, 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800', 'adventure', 4.6),
('Spiti Valley Expedition', 'Spiti Valley, Himachal Pradesh', 'Journey through one of India''s most remote high-altitude cold deserts. Explore ancient Buddhist monasteries like Key and Tabo, frozen rivers, and stunning landscapes at over 12,000 feet above sea level.', 8, 28000.00, 10, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 'adventure', 4.8),
('Coorg Trek & Waterfall Trail', 'Coorg, Karnataka', 'Trek through misty coffee plantations, explore hidden waterfalls like Abbey Falls and Iruppu Falls, spot exotic birds, and experience the rich warrior culture of the Kodava people in the Scotland of India.', 4, 11000.00, 15, 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800', 'adventure', 4.5),
('Chopta Tungnath Trek', 'Chopta, Uttarakhand', 'Trek to the highest Shiva temple in the world at Tungnath and the dramatic Chandrashila summit. Walk through stunning rhododendron forests, enjoy panoramic Himalayan views including Nanda Devi and Trishul.', 5, 13000.00, 12, 'https://images.unsplash.com/photo-1461301214746-1e109215d6d3?w=800', 'adventure', 4.7),
('Dzukou Valley Trek', 'Nagaland & Manipur Border', 'Trek to the legendary Valley of Flowers of the Northeast. The breathtaking Dzukou Valley blooms with rare seasonal flowers, offers dramatic ridgeline camping, and stunning views across the Northeast Himalayan ranges.', 5, 16000.00, 10, 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800', 'adventure', 4.6),
('Sandakphu Trek — Sleeping Buddha', 'Darjeeling, West Bengal', 'Trek to the highest peak in West Bengal for the iconic Sleeping Buddha view — four of the world''s five highest peaks visible at once: Everest, Kangchenjunga, Lhotse, and Makalu.', 6, 18000.00, 12, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 'adventure', 4.7),
('Paragliding in Bir Billing', 'Bir Billing, Himachal Pradesh', 'Soar over the Himalayan valleys from Bir Billing, the paragliding capital of India and one of the best paragliding sites in the world. Includes tandem flights, camping, and monastery visits.', 3, 10000.00, 15, 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800', 'adventure', 4.6),
('Valley of Flowers Trek', 'Chamoli, Uttarakhand', 'Trek through the UNESCO World Heritage Valley of Flowers National Park bursting with hundreds of species of alpine wildflowers. Continue to Hemkund Sahib, a sacred Sikh shrine at 4,300 meters.', 6, 17000.00, 12, 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800', 'adventure', 4.8),

-- ═══════════════════════════════════════════════
-- BEACH (10)
-- ═══════════════════════════════════════════════
('Goa Beach Bliss', 'Goa, India', 'Sun, sand, and sea! Enjoy pristine beaches, vibrant nightlife, water sports, and delicious seafood in the party capital of India. Explore Baga, Anjuna, Calangute, Palolem and secret beaches.', 5, 18000.00, 20, 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800', 'beach', 4.6),
('Andaman Island Escape', 'Port Blair, Havelock Island', 'Discover pristine coral reefs, turquoise waters, and white sand beaches. Snorkeling, scuba diving, and island hopping in this tropical paradise. Visit Radhanagar Beach, rated best in Asia.', 6, 30000.00, 14, 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800', 'beach', 4.8),
('Lakshadweep Island Paradise', 'Agatti Island, Lakshadweep', 'Experience India''s most pristine coral islands with crystal clear lagoons, incredible snorkeling, glass-bottom boat rides, kayaking, and untouched natural beauty in the Arabian Sea.', 5, 35000.00, 10, 'https://images.unsplash.com/photo-1488085061387-422e29b40080?w=800', 'beach', 4.9),
('Varkala Cliffside Retreat', 'Varkala, Kerala', 'Relax on stunning cliff-top beaches with mineral springs, enjoy Ayurvedic spa treatments, watch breathtaking sunsets over the Arabian Sea, and explore the 2000-year-old Janardanaswamy Temple.', 4, 14000.00, 16, 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800', 'beach', 4.5),
('Pondicherry French Riviera', 'Pondicherry, Tamil Nadu', 'Explore the charming French Quarter with colonial architecture, relax on rocky beaches, visit Sri Aurobindo Ashram, enjoy French-Tamil fusion cuisine, cycle through heritage streets, and watch sunrise at Promenade Beach.', 3, 10000.00, 18, 'https://images.unsplash.com/photo-1477587458883-47145ed94245?w=800', 'beach', 4.4),
('Tarkarli Scuba & Beach Stay', 'Tarkarli, Maharashtra', 'Dive into crystal clear waters of the Karli river meeting the Arabian Sea. Enjoy scuba diving with visibility up to 20 feet, water sports, stay on a houseboat, and feast on authentic Malvani seafood.', 4, 12000.00, 15, 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800', 'beach', 4.5),
('Diu Island Heritage & Beach', 'Diu, Dadra & Nagar Haveli', 'Explore the tiny Portuguese island of Diu with stunning forts, colonial churches, serene Nagoa Beach, Ghoghla Beach, and the peaceful laid-back vibe that makes it one of India''s most underrated coastal gems.', 3, 9000.00, 16, 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800', 'beach', 4.3),
('Radhanagar & Neil Island Hop', 'Andaman Islands', 'Explore the stunning Neil Island with natural rock formations, pristine beaches, coral reefs, and the peaceful village life. Combine with the legendary Radhanagar Beach for the ultimate island experience.', 5, 26000.00, 12, 'https://images.unsplash.com/photo-1488085061387-422e29b40080?w=800', 'beach', 4.7),
('Kovalam Lighthouse Beach', 'Kovalam, Kerala', 'Relax at Kerala''s most famous beach resort town dominated by a lighthouse. Enjoy Ayurvedic massages, surf lessons, fresh lobster dinners, sunset views from the lighthouse, and boat rides along the coast.', 4, 15000.00, 14, 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800', 'beach', 4.5),
('Chilika Lake & Puri Beach', 'Puri & Chilika, Odisha', 'Visit Asia''s largest brackish water lake to spot Irrawaddy dolphins, flamingos and migratory birds. Combine with the spiritual town of Puri, the famous Jagannath Temple, and the beautiful Golden Beach.', 5, 13000.00, 18, 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800', 'beach', 4.4),

-- ═══════════════════════════════════════════════
-- CULTURAL (10)
-- ═══════════════════════════════════════════════
('Golden Triangle Adventure', 'Delhi, Agra, Jaipur', 'Explore India''s most iconic cities — the majestic Taj Mahal, vibrant markets of Jaipur, and historic Delhi. A perfect cultural journey through India''s royal Mughal and Rajput heritage sites.', 7, 25000.00, 15, 'https://images.unsplash.com/photo-1548013146-72479768bada?w=800', 'cultural', 4.8),
('Rajasthan Royal Tour', 'Jaipur, Jodhpur, Udaipur', 'Live like royalty as you explore magnificent forts, ornate palaces, camel safaris in Thar Desert, and colorful bazaars of the Land of Kings. A journey through timeless Rajasthani grandeur and hospitality.', 8, 35000.00, 10, 'https://images.unsplash.com/photo-1477587458883-47145ed94245?w=800', 'cultural', 4.9),
('Mysore Cultural Heritage', 'Mysore, Karnataka', 'Experience the grandeur of Mysore Palace, fragrant sandalwood markets, silk weaving centers, Brindavan Gardens, Chamundi Hills, and the spectacular Dasara festival celebrations in the City of Palaces.', 4, 12000.00, 20, 'https://images.unsplash.com/photo-1608023136037-626dad6a50cc?w=800', 'cultural', 4.5),
('Varanasi Spiritual Journey', 'Varanasi, Uttar Pradesh', 'Witness the eternal city on the banks of the Ganges. Experience the mesmerizing Ganga Aarti, boat rides at sunrise, ancient ghats, Sarnath Buddhist ruins, silk weaving workshops, and the profound spiritual energy of Kashi.', 4, 13000.00, 12, 'https://images.unsplash.com/photo-1561361058-c24e021e5e58?w=800', 'cultural', 4.7),
('Hampi Ruins Explorer', 'Hampi, Karnataka', 'Walk through the UNESCO World Heritage ruins of the Vijayanagara Empire. Explore stunning boulder landscapes, the Virupaksha Temple, Vittala Temple with its musical pillars, royal enclosures, and ancient bazaar streets.', 3, 9000.00, 15, 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800', 'cultural', 4.6),
('Khajuraho & Orchha Heritage', 'Khajuraho & Orchha, Madhya Pradesh', 'Marvel at the UNESCO World Heritage erotic temples of Khajuraho, masterpieces of medieval Indian sculpture. Continue to Orchha to explore stunning cenotaphs, riverside temples, and Bundela royal palaces.', 4, 14000.00, 14, 'https://images.unsplash.com/photo-1548013146-72479768bada?w=800', 'cultural', 4.6),
('Amritsar Golden Temple Pilgrimage', 'Amritsar, Punjab', 'Experience the breathtaking Golden Temple — the holiest shrine of Sikhism. Witness the emotional Wagah Border ceremony, explore Jallianwala Bagh, taste authentic Punjabi food at the langar, and feel the warmth of Punjab.', 3, 8000.00, 20, 'https://images.unsplash.com/photo-1477587458883-47145ed94245?w=800', 'cultural', 4.8),
('Mahabalipuram & Kanchipuram', 'Mahabalipuram & Kanchipuram, Tamil Nadu', 'Explore the stunning Shore Temple and rock-cut rathas of Mahabalipuram carved by Pallava kings. Visit Kanchipuram — the city of 1000 temples — and its master silk weavers creating world-famous Kanjivaram sarees.', 3, 9500.00, 16, 'https://images.unsplash.com/photo-1608023136037-626dad6a50cc?w=800', 'cultural', 4.5),
('Kolkata Heritage & Arts Trail', 'Kolkata, West Bengal', 'Discover the City of Joy with its colonial Victoria Memorial, the Indian Museum, Durga Puja pandals, Kumartuli potter''s quarter, tram rides, Park Street food culture, and the vibrant intellectual and artistic spirit of Bengal.', 4, 11000.00, 18, 'https://images.unsplash.com/photo-1561361058-c24e021e5e58?w=800', 'cultural', 4.5),
('Ajanta & Ellora Cave Wonders', 'Aurangabad, Maharashtra', 'Explore two of India''s greatest UNESCO World Heritage Sites — the stunning Buddhist cave paintings of Ajanta and the rock-cut Hindu, Buddhist, and Jain temples of Ellora carved out of solid rock over centuries.', 4, 13000.00, 15, 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800', 'cultural', 4.7),

-- ═══════════════════════════════════════════════
-- WILDLIFE (10)
-- ═══════════════════════════════════════════════
('Jim Corbett Wildlife Safari', 'Jim Corbett National Park, Uttarakhand', 'India''s oldest national park offers thrilling jeep safaris in search of the Royal Bengal Tiger, Asian elephants, leopards, and over 600 bird species in the scenic foothills of the Himalayas.', 4, 18000.00, 10, 'https://images.unsplash.com/photo-1504173010664-32509107de1b?w=800', 'wildlife', 4.7),
('Ranthambore Tiger Reserve', 'Ranthambore, Rajasthan', 'One of India''s best places to spot tigers in the wild. Explore the historic Ranthambore Fort within the park, enjoy sunrise and sunset safaris, and witness raw predator-prey drama in the Rajasthan wilderness.', 4, 20000.00, 8, 'https://images.unsplash.com/photo-1561731216-c3a4d99437d5?w=800', 'wildlife', 4.8),
('Kaziranga Elephant Safari', 'Kaziranga, Assam', 'Home to the world''s largest population of Indian one-horned rhinoceros and a UNESCO World Heritage Site. Enjoy jeep and elephant-back safaris, spot wild buffalo, tigers, and hundreds of bird species.', 5, 22000.00, 10, 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800', 'wildlife', 4.8),
('Sundarbans Mangrove Safari', 'Sundarbans, West Bengal', 'Cruise through the world''s largest mangrove delta, spot the elusive Royal Bengal Tiger swimming between islands, see saltwater crocodiles, Irrawaddy dolphins, and incredible diverse bird life.', 4, 16000.00, 12, 'https://images.unsplash.com/photo-1574482620426-c8b0b1e4f1e7?w=800', 'wildlife', 4.5),
('Periyar Wildlife Sanctuary', 'Thekkady, Kerala', 'Take a boat cruise on Periyar Lake surrounded by dense forests, spot wild elephants bathing on the banks, observe tigers, leopards, gaur, sloth bears, and rare Malabar birds in God''s Own Country.', 4, 15000.00, 14, 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800', 'wildlife', 4.6),
('Bandhavgarh Tiger Safari', 'Bandhavgarh, Madhya Pradesh', 'Bandhavgarh has the highest density of Bengal tigers in India, offering excellent sighting chances. Explore ancient ruins of Bandhavgarh Fort, spot leopards, sloth bears, deer, and over 250 bird species.', 4, 21000.00, 8, 'https://images.unsplash.com/photo-1561731216-c3a4d99437d5?w=800', 'wildlife', 4.8),
('Gir Lion Safari', 'Gir National Park, Gujarat', 'Visit the last wild habitat of the Asiatic Lion on Earth. Explore the Gir Forest with expert naturalists, spot lions, leopards, hyenas, jackals, crocodiles, and the unique Maldhari tribal villages within the forest.', 4, 17000.00, 10, 'https://images.unsplash.com/photo-1504173010664-32509107de1b?w=800', 'wildlife', 4.7),
('Bharatpur Bird Sanctuary', 'Bharatpur, Rajasthan', 'Keoladeo National Park is a UNESCO World Heritage Site and one of the world''s most important bird sanctuaries. Spot thousands of resident and migratory birds including the rare Siberian Crane during winter.', 3, 10000.00, 15, 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800', 'wildlife', 4.5),
('Nagarhole & Kabini Safari', 'Kabini, Karnataka', 'The Kabini reservoir in Nagarhole National Park is famous for spectacular wildlife congregations at the waterhole. Spot tigers, leopards, wild dogs, massive herds of elephants crossing the river, and otters.', 4, 19000.00, 10, 'https://images.unsplash.com/photo-1574482620426-c8b0b1e4f1e7?w=800', 'wildlife', 4.7),
('Manas Wildlife Sanctuary', 'Manas, Assam', 'A UNESCO Natural World Heritage Site and Project Tiger reserve. Spot the rare golden langur, pygmy hog, hispid hare, Bengal florican, and wild water buffalo in the stunning foothills of Bhutan.', 5, 20000.00, 10, 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800', 'wildlife', 4.6),

-- ═══════════════════════════════════════════════
-- LUXURY (10)
-- ═══════════════════════════════════════════════
('Kerala Backwaters Luxury', 'Alleppey, Kerala', 'Cruise through serene backwaters on a premium air-conditioned houseboat with a private chef. Indulge in authentic Ayurvedic treatments, sunset cocktails on deck, and gourmet Kerala cuisine.', 6, 45000.00, 8, 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800', 'luxury', 4.9),
('Palace Hotels of Rajasthan', 'Udaipur, Jodhpur, Jaisalmer', 'Stay in converted maharaja palaces and heritage havelis. Enjoy private candlelit dinner in the desert, helicopter transfers between cities, butler service, and bespoke cultural experiences curated just for you.', 7, 75000.00, 6, 'https://images.unsplash.com/photo-1477587458883-47145ed94245?w=800', 'luxury', 5.0),
('Maldives Extension from India', 'Male, Maldives', 'Fly to the Maldives for an ultra-luxury overwater villa experience. Private infinity pool, world-class coral reef diving, sunset dolphin cruise, private sandbank dinner, and gourmet dining under a blanket of stars.', 5, 90000.00, 4, 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800', 'luxury', 5.0),
('Coorg Luxury Plantation Stay', 'Coorg, Karnataka', 'Stay in a luxury plantation bungalow surrounded by sprawling coffee and spice estates. Enjoy a private plunge pool, personalised coffee farm tours, gourmet plantation meals, signature spa treatments, and guided nature walks.', 4, 38000.00, 6, 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800', 'luxury', 4.8),
('Taj Mahal Luxury Experience', 'Agra & Delhi, Uttar Pradesh', 'Stay at the iconic Oberoi Amarvilas with a direct view of the Taj Mahal from every room. Enjoy private sunrise Taj viewing, gourmet dining, spa treatments, exclusive guided heritage tours, and luxury transfers.', 4, 65000.00, 4, 'https://images.unsplash.com/photo-1548013146-72479768bada?w=800', 'luxury', 5.0),
('Luxury Sikkim & Gangtok', 'Gangtok, Sikkim', 'Stay in luxury mountain resorts with panoramic views of Kangchenjunga. Enjoy private monastery tours with a monk guide, helicopter rides over Himalayan peaks, organic farm dining, and sunrise over the third highest mountain.', 5, 50000.00, 6, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 'luxury', 4.8),
('Sri Lanka Luxury Add-on', 'Colombo, Kandy, Sigiriya', 'A short flight from India to Sri Lanka for luxury travel. Stay in boutique colonial tea estate bungalows, explore Sigiriya Rock Fortress, visit the Temple of the Tooth, enjoy spice garden tours, and private beach dinners.', 6, 70000.00, 6, 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800', 'luxury', 4.9),
('Luxury Houseboat — Dal Lake', 'Srinagar, Jammu & Kashmir', 'Stay on a magnificent carved wooden houseboat on the legendary Dal Lake. Enjoy shikara rides through floating gardens, private Mughal garden tours, Kashmiri wazwan cuisine, and snow-capped mountain views.', 5, 42000.00, 6, 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800', 'luxury', 4.8),
('Luxury Goa Villa Retreat', 'North Goa, Goa', 'Stay in a private heritage Portuguese villa with a personal pool, butler, and chef. Enjoy private beach access, spa treatments, curated spice tour, sunset yacht cruise, and exclusive Goan culinary masterclass.', 5, 55000.00, 6, 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800', 'luxury', 4.9),
('Luxury Corbett Jungle Lodge', 'Jim Corbett, Uttarakhand', 'Stay in an exclusive luxury jungle lodge at the edge of Corbett National Park. Enjoy private jeep safari with expert naturalists, open-air jacuzzi, bonfire dinners, nature walks, and bird watching at dawn.', 4, 48000.00, 8, 'https://images.unsplash.com/photo-1504173010664-32509107de1b?w=800', 'luxury', 4.8),

-- ═══════════════════════════════════════════════
-- BUDGET (10)
-- ═══════════════════════════════════════════════
('Hampi Budget Backpacker', 'Hampi, Karnataka', 'Explore the stunning UNESCO ruins of Hampi on a shoestring. Cycle between ancient temples, swim in the Tungabhadra river, stay in cozy guesthouses, eat delicious thali meals, and watch sunset from Matanga Hill.', 3, 5000.00, 20, 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800', 'budget', 4.4),
('McLeod Ganj Budget Trek', 'McLeod Ganj, Himachal Pradesh', 'The home of the Dalai Lama offers incredible value. Trek to Triund ridge, explore Tibetan Buddhist culture, eat momos and thukpa, attend morning meditation sessions, and soak in stunning Dhauladhar views.', 4, 7000.00, 20, 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=800', 'budget', 4.5),
('Ooty & Kodaikanal Hills', 'Ooty & Kodaikanal, Tamil Nadu', 'Explore the stunning Nilgiri Hills on a budget. Ride the iconic UNESCO toy train to Ooty, visit beautiful botanical gardens, boat on Kodaikanal lake, trek to Dolphin''s Nose, and enjoy the cool misty hill station air.', 5, 8500.00, 18, 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800', 'budget', 4.3),
('Varanasi Budget Spiritual Tour', 'Varanasi & Sarnath, Uttar Pradesh', 'Experience the spiritual heart of India on a budget. Sunrise boat rides on the Ganges, explore 84 ancient ghats, witness the Ganga Aarti, visit Sarnath, and eat delicious kachori and lassi at street stalls.', 3, 6000.00, 20, 'https://images.unsplash.com/photo-1561361058-c24e021e5e58?w=800', 'budget', 4.4),
('Northeast India Explorer', 'Shillong, Cherrapunji, Meghalaya', 'Discover hidden gems of Northeast India. Visit incredible living root bridges, explore the wettest place on Earth, trek to stunning waterfalls like Nohkalikai, and experience the unique Khasi tribal culture of Meghalaya.', 5, 9500.00, 15, 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800', 'budget', 4.6),
('Pushkar Budget Desert Tour', 'Pushkar, Rajasthan', 'Visit one of India''s holiest cities on a tight budget. Explore the only Brahma Temple in the world, take a camel safari at sunset, swim in the sacred Pushkar Lake, enjoy the colorful Pushkar Camel Fair, and eat cheap dal baati.', 3, 5500.00, 20, 'https://images.unsplash.com/photo-1477587458883-47145ed94245?w=800', 'budget', 4.3),
('Pondicherry Budget Escape', 'Pondicherry, Tamil Nadu', 'Explore the charming French Quarter, meditate at Auroville, relax on free beaches, eat cheap French-Tamil food at street cafes, cycle through heritage streets, and enjoy beautiful sunrises at Promenade Beach.', 3, 6500.00, 20, 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800', 'budget', 4.4),
('Spiti on a Budget', 'Spiti Valley, Himachal Pradesh', 'Experience the breathtaking landscapes of Spiti Valley without breaking the bank. Stay in homestays with local families, travel by local buses, visit Key Monastery, Chandratal Lake, and Pin Valley National Park.', 7, 12000.00, 15, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 'budget', 4.5),
('Amritsar Budget Pilgrimage', 'Amritsar, Punjab', 'Experience the golden glow of the Harmandir Sahib — the Golden Temple — completely free. Eat unlimited free langar meals, witness the emotional Wagah Border closing ceremony, explore Jallianwala Bagh, and enjoy lassi and kulchas.', 2, 4000.00, 20, 'https://images.unsplash.com/photo-1477587458883-47145ed94245?w=800', 'budget', 4.7),
('Rishikesh Budget Yoga & Rafting', 'Rishikesh, Uttarakhand', 'The yoga capital of the world is also incredibly budget-friendly. Attend free yoga and meditation classes on the ghats, go river rafting, cross the iconic Lakshman Jhula, eat at cheap ashram restaurants, and attend Ganga Aarti.', 4, 7500.00, 20, 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800', 'budget', 4.5);