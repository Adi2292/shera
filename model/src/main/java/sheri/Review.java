package sheri;

import java.io.Serializable;

public class Review implements Serializable {
    private String username;
    private String profileName;
    private int rating;
    private String comment;

    public Review(String username, String profileName, int rating, String comment) {
        this.username = username;
        this.profileName = profileName;
        this.rating = rating;
        this.comment = comment;
    }

    public String getUsername() {
        return username;
    }

    public String getProfileName() {
        return profileName;
    }

    public int getRating() {
        return rating;
    }

    public String getComment() {
        return comment;
    }
}
