package com.gym.model;

public class VerifiedReview extends Review {

    private String verifiedSince;

    public VerifiedReview(int reviewId, int memberId, String memberName, int rating,
                          String comment, String category, String reviewDate,
                          String reviewType, String status, String verifiedSince) {
        super(reviewId, memberId, memberName, rating, comment, category,
              reviewDate, reviewType, status);
        this.verifiedSince = verifiedSince;
    }

    public VerifiedReview(int reviewId, int memberId, String memberName, int rating,
                          String comment, String category, String reviewDate,
                          String reviewType, String status) {
        super(reviewId, memberId, memberName, rating, comment, category,
              reviewDate, reviewType, status);
        this.verifiedSince = reviewDate;
    }

    public VerifiedReview() {
        super();
    }

   
    @Override
    public String getDisplayBadge() {
        return "Verified Member \u2713"; 
    }

    @Override
    public boolean canEdit() {
        return false;
    }

    @Override
    public String getRole() {
        return "VERIFIED_REVIEW";
    }

    @Override
    public String getDisplayInfo() {
        return "\u2713 VERIFIED | " +
               getRatingStars() +
               " | [" + getCategory() + "] " +
               getComment() +
               " | by " + getMemberName() +
               " (verified since " + verifiedSince + ")";
    }

    public String getVerifiedSince() {
        return verifiedSince;
    }

    public void setVerifiedSince(String verifiedSince) {
        this.verifiedSince = verifiedSince;
    }
}
