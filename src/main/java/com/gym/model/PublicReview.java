package com.gym.model;

public class PublicReview extends Review {

    public PublicReview(int reviewId, int memberId, String memberName, int rating,
                        String comment, String category, String reviewDate,
                        String reviewType, String status) {
        super(reviewId, memberId, memberName, rating, comment, category,
              reviewDate, reviewType, status);
    }

    public PublicReview() {
        super();
    }

    @Override
    public String getDisplayBadge() {
        return "Member Review";
    }

    @Override
    public boolean canEdit() {
        return true;
    }

    @Override
    public String getRole() {
        return "PUBLIC_REVIEW";
    }

    @Override
    public String getDisplayInfo() {
        return getRatingStars() +
               " | [" + getCategory() + "] " +
               getComment() +
               " | by " + getMemberName() +
               " on " + getReviewDate();
    }
}
