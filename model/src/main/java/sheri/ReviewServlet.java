package sheri;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DIRECTORY_PATH = "C:/event_reviews/"; // update to your actual path

    @Override
    public void init() throws ServletException {
        File dir = new File(DIRECTORY_PATH);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String selectedProfile = request.getParameter("selectedProfile");

        if (action != null && action.equals("delete")) {
            handleDelete(request);
        } else if (action != null && action.equals("edit")) {
            handleEdit(request);
        } else {
            // Normal review submission
            String username = request.getParameter("username");
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            Review review = new Review(username, selectedProfile, rating, comment);
            saveReviewToFile(review);
        }

        // Reload reviews
        List<Review> reviews = loadReviewsFromFile(selectedProfile);
        request.setAttribute("reviews", reviews);
        request.setAttribute("selectedProfile", selectedProfile);
        request.getRequestDispatcher("past_reviews.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String selectedProfile = request.getParameter("selectedProfile");
        String redirectPage = request.getParameter("redirect");

        if (selectedProfile != null) {
            List<Review> reviews = loadReviewsFromFile(selectedProfile);
            request.setAttribute("reviews", reviews);
            request.setAttribute("selectedProfile", selectedProfile);
        }

        if (redirectPage != null) {
            request.getRequestDispatcher(redirectPage).forward(request, response);
        } else {
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    private void handleDelete(HttpServletRequest request) throws IOException {
        String selectedProfile = request.getParameter("selectedProfile");
        String username = request.getParameter("username");
        String comment = request.getParameter("comment");

        List<Review> reviews = loadReviewsFromFile(selectedProfile);
        reviews.removeIf(r -> r.getUsername().equals(username) && r.getComment().equals(comment));
        overwriteReviewFile(selectedProfile, reviews);
    }

    private void handleEdit(HttpServletRequest request) throws IOException {
        String selectedProfile = request.getParameter("selectedProfile");
        String originalUsername = request.getParameter("originalUsername");
        String originalComment = request.getParameter("originalComment");

        String updatedUsername = request.getParameter("username");
        int updatedRating = Integer.parseInt(request.getParameter("rating"));
        String updatedComment = request.getParameter("comment");

        List<Review> reviews = loadReviewsFromFile(selectedProfile);

        for (int i = 0; i < reviews.size(); i++) {
            Review r = reviews.get(i);
            if (r.getUsername().equals(originalUsername) && r.getComment().equals(originalComment)) {
                reviews.set(i, new Review(updatedUsername, selectedProfile, updatedRating, updatedComment));
                break;
            }
        }

        overwriteReviewFile(selectedProfile, reviews);
    }

    private void saveReviewToFile(Review review) throws IOException {
        String filename = DIRECTORY_PATH + review.getProfileName() + ".txt";
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filename, true))) {
            writer.write(review.getUsername() + "|" + review.getRating() + "|" + review.getComment());
            writer.newLine();
        }
    }

    private void overwriteReviewFile(String profileName, List<Review> reviews) throws IOException {
        String filename = DIRECTORY_PATH + profileName + ".txt";
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filename))) {
            for (Review review : reviews) {
                writer.write(review.getUsername() + "|" + review.getRating() + "|" + review.getComment());
                writer.newLine();
            }
        }
    }

    public static List<Review> loadReviewsFromFile(String profileName) throws IOException {
        List<Review> reviews = new ArrayList<>();
        String filename = DIRECTORY_PATH + profileName + ".txt";
        File file = new File(filename);

        if (file.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] parts = line.split("\\|");
                    if (parts.length == 3) {
                        reviews.add(new Review(parts[0], profileName, Integer.parseInt(parts[1]), parts[2]));
                    }
                }
            }
        }
        return reviews;
    }
}
