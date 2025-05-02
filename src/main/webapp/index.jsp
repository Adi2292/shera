
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="sheri.Review" %>

<!DOCTYPE html>
<html>
<head>
    <title>Reviews & Ratings</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css">
    <style>
        body {
            background-color: black;
            color: white;
        }
        .container {
            background-color: #1a1a1a;
            border: 2px solid gold;
        }
        button {
            background-color: gold;
            color: black;
        }
        button:hover {
            background: #21a13a;
            transition: 0.3s ease-in-out;
        }
    </style>
    <script>
        let profiles = [
            { name: "Kamal", role: "Photographer", image: "p11.jpg" },
            { name: "Sunil", role: "Photographer", image: "p22.jpg" },
            { name: "Amal", role: "Photographer", image: "p33.jpg" },
            { name: "Saman", role: "Photographer", image: "p4.jpg" },
            { name: "Gihan", role: "Videographer", image: "p5.jpg" },
            { name: "Sehan", role: "Videographer", image: "p6.jpg" }
        ];

        let currentIndex = 0;

        function updateProfile() {
            let profile = profiles[currentIndex];
            document.getElementById("profile-image").src = profile.image;
            document.getElementById("profile-name").innerText = profile.name;
            document.getElementById("profile-role").innerText = profile.role;
            document.getElementById("selectedProfile").value = profile.name;
        }

        function nextProfile() {
            currentIndex = (currentIndex + 1) % profiles.length;
            updateProfile();
        }

        function prevProfile() {
            currentIndex = (currentIndex - 1 + profiles.length) % profiles.length;
            updateProfile();
        }

        function loadReviews() {
            let profileName = profiles[currentIndex].name;
            window.location.href = "ReviewServlet?selectedProfile=" + encodeURIComponent(profileName) + "&redirect=past_reviews.jsp";
        }

        window.onload = updateProfile;
    </script>
</head>
<body class="p-6">
<div class="container max-w-3xl mx-auto p-6 rounded-lg shadow-lg">
    <h2 class="text-xl font-semibold mb-4 text-gold">Reviews & Ratings</h2>

    <!-- Photographer & Videographer Profile -->
    <div class="flex items-center justify-center mb-6">
        <button onclick="prevProfile()" class="px-4 py-2 rounded-l">&#10094;</button>
        <div class="text-center mx-4">
            <img id="profile-image" src="" alt="Profile" class="w-48 h-48 rounded-full mx-auto border-4 border-gold">
            <p id="profile-name" class="mt-2 font-semibold text-gold"></p>
            <p id="profile-role" class="text-gray-400"></p>
            <!-- Button to View Past Reviews -->
            <button onclick="loadReviews()" class="mt-2 px-4 py-2 rounded">View Past Reviews</button>
        </div>
        <button onclick="nextProfile()" class="px-4 py-2 rounded-r">&#10095;</button>
    </div>



    <!-- Review Submission Form -->
    <form action="ReviewServlet" method="post" class="space-y-4">
        <input type="hidden" name="selectedProfile" id="selectedProfile">

        <label class="block">
            <span class="text-gold">Your Name:</span>
            <input type="text" name="username" class="w-full p-2 border rounded text-black" required>
        </label>

        <label class="block">
            <span class="text-gold">Rating (1-5):</span>
            <select name="rating" class="w-full p-2 border rounded text-black" required>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
            </select>
        </label>

        <label class="block">
            <span class="text-gold">Your Review:</span>
            <textarea name="comment" rows="3" class="w-full p-2 border rounded text-black" required></textarea>
        </label>

        <div class="flex justify-center">
            <button type="submit" class="px-6 py-2 rounded">Submit Review</button>
        </div>
    </form>

    <!-- Display Reviews -->
    <div class="mb-6">
        <% List<Review> reviews = (List<Review>) request.getAttribute("reviews");
            if (reviews != null && !reviews.isEmpty()) {
                for (Review review : reviews) { %>
        <div class="border-b pb-3 mb-3 border-gold">
            <p class="text-gray-300"><strong><%= review.getUsername() %></strong> rated <%= review.getRating() %>/5</p>
            <p class="text-gray-400 italic">"<%= review.getComment() %>"</p>
        </div>
        <% }
        } else { %>
        <p class="text-gray-500">No reviews yet. Be the first to review!</p>
        <% } %>
    </div>
    <div class="text-center mt-4">
        <a href="SortedProfilesServlet" class="bg-yellow-500 hover:bg-yellow-600 text-black px-4 py-2 rounded transition">View Sorted Photographers</a>
    </div>


</div>
</body>
</html>