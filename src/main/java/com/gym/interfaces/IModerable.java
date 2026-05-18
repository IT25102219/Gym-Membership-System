/*
 * FILE          : IModerable.java
 * PACKAGE       : com.gym.interfaces
 * PURPOSE       : Defines the content moderation contract for reviews.
 *                 Admins can approve or remove reviews through this interface.
 * OOP CONCEPT   : ABSTRACTION — defines WHAT moderation actions are available.
 *                 The moderateReviews.jsp and ReviewServlet only need to know
 *                 that a review can be approved/removed — not HOW it is done.
 * IMPLEMENTED BY: Review (abstract), PublicReview, VerifiedReview
 * WHY           : If we add a new content type (e.g., BlogPost) that needs
 *                 moderation, it just implements IModerable. The admin panel
 *                 servlet already knows how to call approve()/remove() on it.
 */
package com.gym.interfaces;

// INTERFACE : IModerable
// OOP CONCEPT: Abstraction — moderation contract for any user-generated content
// IMPLEMENTED BY: PublicReview, VerifiedReview (via Review abstract class)
// WHY: Allows admin moderation code to work on any content type uniformly
public interface IModerable {

    // METHOD : approve
    // DOES   : Sets the status of this content to "ACTIVE" (makes it visible).
    //          Used to restore a review that was previously removed.
    //          Changes the 'status' field from "REMOVED" back to "ACTIVE".
    // CALLED : ReviewServlet when admin clicks "Restore" on moderateReviews.jsp
    // RETURNS: true if approved successfully, false if something went wrong
    boolean approve();

    // METHOD : remove
    // DOES   : Sets the status of this content to "REMOVED" (hides it from public).
    //          This is a SOFT DELETE — the data stays in the database.
    //          Why soft delete? Admin can restore it later; data preserved for auditing.
    // CALLED : ReviewServlet when admin clicks "Remove" on moderateReviews.jsp
    // RETURNS: true if removed successfully, false if something went wrong
    boolean remove();

    // METHOD : getModerationStatus
    // DOES   : Returns the current moderation status of this content.
    //          Returns "ACTIVE" or "REMOVED".
    //          Used to display status badge on moderateReviews.jsp
    // CALLED : moderateReviews.jsp to show current status next to each review
    String getModerationStatus();
}
