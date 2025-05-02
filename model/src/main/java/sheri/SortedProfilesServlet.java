package sheri;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/SortedProfilesServlet")
public class SortedProfilesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get all profiles with their average ratings
        List<ProfileRating> profileRatings = calculateAverageRatings();

        // Sort using bubble sort
        bubbleSort(profileRatings);

        request.setAttribute("profileRatings", profileRatings);
        request.getRequestDispatcher("sorted_profiles.jsp").forward(request, response);
    }

    public static List<ProfileRating> calculateAverageRatings() {
        List<ProfileRating> profileRatings = new ArrayList<>();
        String[] profileNames = {"Kamal", "Sunil", "Amal", "Saman", "Gihan", "Sehan"};

        for (String profileName : profileNames) {
            try {
                List<Review> reviews = ReviewServlet.loadReviewsFromFile(profileName);
                if (!reviews.isEmpty()) {
                    double sum = 0;
                    for (Review review : reviews) {
                        sum += review.getRating();
                    }
                    double average = sum / reviews.size();
                    profileRatings.add(new ProfileRating(profileName, average, reviews.size()));
                } else {
                    profileRatings.add(new ProfileRating(profileName, 0.0, 0));
                }
            } catch (IOException e) {
                profileRatings.add(new ProfileRating(profileName, 0.0, 0));
            }
        }

        return profileRatings;
    }

    private void bubbleSort(List<ProfileRating> list) {
        int n = list.size();
        for (int i = 0; i < n-1; i++) {
            for (int j = 0; j < n-i-1; j++) {
                if (list.get(j).getAverageRating() < list.get(j+1).getAverageRating()) {
                    // Swap
                    ProfileRating temp = list.get(j);
                    list.set(j, list.get(j+1));
                    list.set(j+1, temp);
                }
            }
        }
    }
}

