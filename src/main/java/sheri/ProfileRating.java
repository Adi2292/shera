package sheri;

public class ProfileRating {
    private String profileName;
    private double averageRating;
    private int reviewCount;

    public ProfileRating(String profileName, double averageRating, int reviewCount) {
        this.profileName = profileName;
        this.averageRating = averageRating;
        this.reviewCount = reviewCount;
    }

    // Getters
    public String getProfileName() { return profileName; }
    public double getAverageRating() { return averageRating; }
    public int getReviewCount() { return reviewCount; }
}
