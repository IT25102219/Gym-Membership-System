/*
 * FILE    : Review.java
 * PACKAGE : com.gym.model
 * PURPOSE : Abstract base class for all member reviews.
 *           Members can leave feedback about gym facilities, trainers, or general experience.
 *           Admins can moderate reviews (approve or remove them).
 *           Subclasses: PublicReview (any member) and VerifiedReview (premium members).
 * OOP     : ABSTRACTION — abstract class + implements IModerable interface
 *           ENCAPSULATION — all review data is private with getters/setters
 *           POLYMORPHISM — getDisplayBadge() returns different badges per review type
 * CONNECTS: Extended by PublicReview.java and VerifiedReview.java
 *           ReviewService creates the correct subclass based on review_type column
 *           viewReviews.jsp shows reviews; moderateReviews.jsp for admin moderation
 */
package com.gym.model;

import com.gym.interfaces.Displayable;
import com.gym.interfaces.IModerable;

// WHAT : Abstract base class for gym member reviews and feedback
// WHY  : Groups all review data in one place; enforces moderation capabilities
// OOP  : ABSTRACTION (abstract class + IModerable) + ENCAPSULATION
public abstract class Review implements IModerable, Displayable {

    // FIELD: reviewId — primary key from the reviews table
    private int reviewId;

    // FIELD: memberId — which member wrote this review (FK to members table)
    private int memberId;

    // FIELD: memberName — stored for easy display (avoids extra DB join for name)
    private String memberName;

    // FIELD: rating — star rating from 1 to 5
    // 1 = very poor, 5 = excellent. Stored as TINYINT in DB.
    private int rating;

    // FIELD: comment — the written text of the review (free-form text)
    private String comment;

    // FIELD: category — what aspect of the gym is being reviewed
    // Values: "FACILITY", "TRAINER", "GENERAL"
    private String category;

    // FIELD: reviewDate — when this review was submitted (format: "YYYY-MM-DD HH:MM:SS")
    private String reviewDate;

    // FIELD: reviewType — "PUBLIC" or "VERIFIED"
    // Determines which subclass ReviewService creates when reading from DB
    private String reviewType;

    // FIELD: status — "ACTIVE" (visible) or "REMOVED" (soft deleted by admin)
    private String status;

    // ============================================================
    // CONSTRUCTORS
    // ============================================================

    // METHOD : Review (full constructor)
    // DOES   : Initialises all review fields.
    // CALLED : PublicReview and VerifiedReview constructors via super(...)
    public Review(int reviewId, int memberId, String memberName, int rating,
                  String comment, String category, String reviewDate,
                  String reviewType, String status) {
        this.reviewId = reviewId;
        this.memberId = memberId;
        this.memberName = memberName;
        this.rating = rating;
        this.comment = comment;
        this.category = category;
        this.reviewDate = reviewDate;
        this.reviewType = reviewType;
        this.status = status;
    }

    // Default constructor for building object field by field
    public Review() {}

    // ============================================================
    // ABSTRACT METHODS — each review subclass implements these differently
    // ============================================================

    // METHOD : getDisplayBadge (abstract)
    // DOES   : Returns the trust/verification badge for this review type.
    //          PublicReview   → "Member Review"
    //          VerifiedReview → "Verified Member ✓"
    // CALLED : viewReviews.jsp to show the appropriate badge on each review card
    public abstract String getDisplayBadge();

    // METHOD : canEdit (abstract)
    // DOES   : Returns whether this review type can be edited by the author.
    //          PublicReview   → true  (public reviews can be edited anytime)
    //          VerifiedReview → false (verified reviews are locked for integrity)
    // CALLED : myReviews.jsp to show/hide the Edit button per review
    public abstract boolean canEdit();

    // ============================================================
    // CONCRETE IMPLEMENTATIONS from IModerable
    // These work the same for ALL review types
    // ============================================================

    // METHOD : approve
    // DOES   : Makes this review visible by setting status to "ACTIVE".
    //          Used by admin to restore a previously removed review.
    // CALLED : ReviewServlet when admin clicks "Restore" on moderateReviews.jsp
    // RETURNS: true after changing status to ACTIVE
    @Override
    public boolean approve() {
        // Change status to ACTIVE — the review becomes publicly visible again
        this.status = "ACTIVE";
        return true; // status changed successfully
    }

    // METHOD : remove
    // DOES   : Hides this review by setting status to "REMOVED".
    //          SOFT DELETE — data stays in database, admin can restore it.
    //          Why soft delete? Preserves review history; admin can reverse mistakes.
    // CALLED : ReviewServlet when admin clicks "Remove" on moderateReviews.jsp
    // RETURNS: true after changing status to REMOVED
    @Override
    public boolean remove() {
        // Change status to REMOVED — review becomes invisible to public
        this.status = "REMOVED";
        return true; // status changed successfully
    }

    // METHOD : getModerationStatus
    // DOES   : Returns the current moderation status: "ACTIVE" or "REMOVED"
    // CALLED : moderateReviews.jsp to show current status badge for each review
    @Override
    public String getModerationStatus() {
        return this.status;
    }

    // ============================================================
    // UTILITY METHOD
    // ============================================================

    // METHOD : getRatingStars
    // DOES   : Converts the numeric rating (1-5) to a visual star string.
    //          Filled stars (★) for the rating, empty stars (☆) for the rest.
    //          Example: rating=4 → "★★★★☆"
    // CALLED : viewReviews.jsp to display visual star ratings on review cards
    public String getRatingStars() {
        // Build the star string by appending filled and empty stars
        StringBuilder stars = new StringBuilder();

        // Add filled stars equal to the rating
        for (int i = 0; i < rating; i++) {
            stars.append("★"); // filled star = this rating level
        }

        // Add empty stars for the remaining positions up to 5
        for (int i = rating; i < 5; i++) {
            stars.append("☆"); // empty star = not reached
        }

        return stars.toString();
        // Example: rating=3 → "★★★☆☆"
    }

    // ============================================================
    // GETTERS
    // ============================================================

    public int getReviewId() { return reviewId; }
    public int getMemberId() { return memberId; }
    public String getMemberName() { return memberName; }
    public int getRating() { return rating; }
    public String getComment() { return comment; }
    public String getCategory() { return category; }
    public String getReviewDate() { return reviewDate; }
    public String getReviewType() { return reviewType; }
    public String getStatus() { return status; }

    // ============================================================
    // SETTERS
    // ============================================================

    public void setReviewId(int reviewId) { this.reviewId = reviewId; }
    public void setMemberId(int memberId) { this.memberId = memberId; }
    public void setMemberName(String memberName) { this.memberName = memberName; }
    public void setRating(int rating) { this.rating = rating; }
    public void setComment(String comment) { this.comment = comment; }
    public void setCategory(String category) { this.category = category; }
    public void setReviewDate(String reviewDate) { this.reviewDate = reviewDate; }
    public void setReviewType(String reviewType) { this.reviewType = reviewType; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Review{id=" + reviewId + ", member='" + memberName +
               "', rating=" + rating + ", type='" + reviewType + "'}";
    }
}
