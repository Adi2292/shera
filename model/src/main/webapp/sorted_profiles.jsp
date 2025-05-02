<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="sheri.ProfileRating" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sorted Photographers</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css">
    <style>
        body {
            background-color: black;
            color: white;
        }
        .profile-card {
            background-color: #1a1a1a;
            border: 2px solid gold;
            transition: transform 0.3s ease;
        }
        .profile-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(218, 165, 32, 0.3);
        }
        .rating-stars {
            color: gold;
            font-size: 1.5rem;
        }
        .rank-badge {
            background-color: gold;
            color: black;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2rem;
        }
    </style>
</head>
<body class="p-6">
<div class="max-w-4xl mx-auto">
    <h1 class="text-3xl font-bold text-center mb-8 text-gold">Top Photographers & Videographers</h1>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <%
            List<ProfileRating> profileRatings = (List<ProfileRating>) request.getAttribute("profileRatings");
            for (int i = 0; i < profileRatings.size(); i++) {
                ProfileRating pr = profileRatings.get(i);
                String imageName = "p" + (i+1) + (i+1) + ".jpg"; // p11.jpg, p22.jpg, etc.
                if (i == 3) imageName = "p4.jpg";
                if (i == 4) imageName = "p5.jpg";
                if (i == 5) imageName = "p6.jpg";
        %>
        <div class="profile-card rounded-lg p-6 flex items-center space-x-6">
            <div class="rank-badge"><%= i+1 %></div>

            <div class="flex-shrink-0">
                <img src="<%= imageName %>" alt="<%= pr.getProfileName() %>"
                     class="w-24 h-24 rounded-full border-4 border-gold object-cover">
            </div>

            <div class="flex-grow">
                <h3 class="text-xl font-bold text-gold"><%= pr.getProfileName() %></h3>
                <div class="flex items-center mt-2">
                    <div class="rating-stars">
                        <% for (int j = 0; j < 5; j++) { %>
                        <% if (j < Math.floor(pr.getAverageRating())) { %>
                        ★
                        <% } else if (j < Math.ceil(pr.getAverageRating()) && pr.getAverageRating() % 1 != 0) { %>
                        ½
                        <% } else { %>
                        ☆
                        <% } %>
                        <% } %>
                    </div>
                    <span class="ml-2 text-gray-400">
                        (<%= String.format("%.1f", pr.getAverageRating()) %> from <%= pr.getReviewCount() %> reviews)
                    </span>
                </div>

                <% if (pr.getAverageRating() >= 4.5) { %>
                <div class="mt-2 text-green-400 font-semibold">⭐ Top Rated</div>
                <% } else if (pr.getAverageRating() >= 3.5) { %>
                <div class="mt-2 text-yellow-400 font-semibold">👍 Recommended</div>
                <% } else if (pr.getAverageRating() > 0) { %>
                <div class="mt-2 text-gray-400">Average</div>
                <% } else { %>
                <div class="mt-2 text-gray-500">No reviews yet</div>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>

    <div class="text-center mt-8">
        <a href="index.jsp"
           class="inline-block bg-gold hover:bg-yellow-600 text-black font-bold py-3 px-6 rounded-lg transition duration-300">
            Back to Main Page
        </a>
    </div>
</div>
</body>
</html>