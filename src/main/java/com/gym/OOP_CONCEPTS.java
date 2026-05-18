/*
 * FILE    : OOP_CONCEPTS.java
 * PACKAGE : com.gym
 * PURPOSE : This file is a VIVA REFERENCE SHEET — a "cheat sheet" for explaining
 *           all four OOP concepts used in this project during your university viva.
 *           This class contains NO executable code — ONLY comments.
 *           Read through this file before your viva to refresh your memory.
 * OOP     : This file itself demonstrates good coding practice — documenting
 *           architectural decisions for future developers (and for viva examiners!).
 */
package com.gym;

/**
 * ============================================================
 * OOP CONCEPTS USED IN THIS PROJECT — VIVA REFERENCE
 * SE1020 — Object Oriented Programming Assignment
 * ============================================================
 *
 * ============================================================
 * CONCEPT 1: ENCAPSULATION
 * ============================================================
 *
 * DEFINITION:
 *   Hiding internal data (fields) inside a class and providing
 *   controlled access through public getters and setters.
 *   The data is "encapsulated" (wrapped up) inside the class.
 *
 * WHERE USED IN THIS PROJECT:
 *   EVERY model class uses encapsulation:
 *   - Person.java     — name, email, phone are ALL private
 *   - Member.java     — memberId, dob, passwordHash are private
 *   - Trainer.java    — trainerId, specialisation, availability are private
 *   - Payment.java    — amount, method, status are private
 *   - Review.java     — rating, comment, status are private
 *
 * CONCRETE EXAMPLE FROM THIS CODE:
 *   In Member.java:
 *     private String passwordHash; // ← private field, CANNOT access directly
 *
 *   From OUTSIDE the class, you CANNOT do this:
 *     member.passwordHash = "newHash"; // ← COMPILE ERROR!
 *
 *   You MUST use the setter:
 *     member.setPasswordHash("newHash"); // ← CORRECT
 *   And to read it:
 *     String hash = member.getPasswordHash(); // ← CORRECT
 *
 * WHY USEFUL:
 *   1. PROTECTION: If someone tries to set an invalid value,
 *      the setter can validate it before storing.
 *   2. FLEXIBILITY: If you change HOW email is stored internally
 *      (e.g., to lowercase), nothing outside the class breaks.
 *   3. SECURITY: passwordHash being private means only MemberService
 *      can access it — no accidental exposure in JSP.
 *
 * VIVA QUESTION: "Where is encapsulation in your project?"
 * ANSWER: "In Member.java, the email field is declared private.
 *          You cannot access it directly from MemberServlet.
 *          You must call getMemberEmail() to read it and
 *          setEmail() to change it. This protects the data."
 *
 *
 * ============================================================
 * CONCEPT 2: INHERITANCE
 * ============================================================
 *
 * DEFINITION:
 *   A child class automatically receives (inherits) all fields
 *   and methods from its parent class WITHOUT copying any code.
 *   The child "IS-A" parent — RegularMember IS-A Member IS-A Person.
 *
 * INHERITANCE TREES IN THIS PROJECT:
 *
 *   Tree 1 — Member Hierarchy (3 levels):
 *     Person (abstract)
 *       └── Member (abstract)
 *             ├── RegularMember  ← CONCRETE (can instantiate)
 *             └── PremiumMember  ← CONCRETE (can instantiate)
 *
 *   Tree 2 — Trainer Hierarchy (3 levels):
 *     Person (abstract)
 *       └── Trainer (abstract)
 *             ├── PersonalTrainer ← CONCRETE
 *             └── GroupTrainer    ← CONCRETE
 *
 *   Tree 3 — Plan Hierarchy (2 levels):
 *     MembershipPlan (abstract)
 *       ├── ShortTermPlan ← CONCRETE
 *       └── LongTermPlan  ← CONCRETE
 *
 *   Tree 4 — Payment Hierarchy (2 levels):
 *     Payment (abstract)
 *       ├── CashPayment   ← CONCRETE
 *       └── OnlinePayment ← CONCRETE
 *
 *   Tree 5 — Review Hierarchy (2 levels):
 *     Review (abstract)
 *       ├── PublicReview   ← CONCRETE
 *       └── VerifiedReview ← CONCRETE
 *
 * CONCRETE EXAMPLE FROM THIS CODE:
 *   RegularMember extends Member extends Person.
 *   RegularMember does NOT declare 'name', 'email', or 'phone'.
 *   It INHERITS them from Person automatically!
 *
 *   When you call regularMember.getName():
 *   → Java looks in RegularMember — NOT FOUND
 *   → Java looks in Member       — NOT FOUND
 *   → Java looks in Person       — FOUND! Returns name.
 *
 *   RegularMember gets Person's fields for FREE — no copy-paste!
 *
 * WHY USEFUL:
 *   1. NO CODE DUPLICATION: name, email, phone defined once in Person,
 *      shared by 4 subclasses (RegularMember, PremiumMember,
 *      PersonalTrainer, GroupTrainer).
 *   2. MAINTAINABILITY: If you want to add a 'secondPhone' field,
 *      add it to Person ONCE — all subclasses get it instantly.
 *
 * VIVA QUESTION: "Show me inheritance in your project."
 * ANSWER: "RegularMember extends Member which extends Person.
 *          RegularMember has no 'name' field declared.
 *          But I can call regularMember.getName() and it works
 *          because it inherits 'name' from Person through Member.
 *          This is a 3-level inheritance chain."
 *
 *
 * ============================================================
 * CONCEPT 3: POLYMORPHISM
 * ============================================================
 *
 * DEFINITION:
 *   The same method name produces DIFFERENT behaviour depending
 *   on which object calls it. "Poly" = many, "morph" = forms.
 *   One method name, many forms of execution.
 *
 * TYPE: Runtime Polymorphism (Method Overriding)
 *   The JVM decides AT RUNTIME which version of the method to call,
 *   based on the ACTUAL object type (not the reference type).
 *
 * EXAMPLES IN THIS PROJECT:
 *
 *   Example 1 — getMonthlyFee():
 *     Member m1 = new RegularMember(...);
 *     Member m2 = new PremiumMember(...);
 *     m1.getMonthlyFee(); // → 2500.0  (RegularMember's version)
 *     m2.getMonthlyFee(); // → 5000.0  (PremiumMember's version)
 *     // Same method call, DIFFERENT result! The JVM picks the right version.
 *
 *   Example 2 — calculateDiscountedPrice():
 *     MembershipPlan p1 = new ShortTermPlan(...);  // price = 2500
 *     MembershipPlan p2 = new LongTermPlan(...);   // price = 20000
 *     p1.calculateDiscountedPrice(); // → 2500.0   (no discount)
 *     p2.calculateDiscountedPrice(); // → 18000.0  (10% off!)
 *
 *   Example 3 — processPayment():
 *     Payment cash   = new CashPayment(...);
 *     Payment online = new OnlinePayment(...);
 *     cash.processPayment();   // → marks PAID, NO TXN ID
 *     online.processPayment(); // → generates TXN ID, then marks PAID
 *     // PaymentServlet calls the SAME line: payment.processPayment()
 *     // But different things happen based on the object!
 *
 *   Example 4 — getSessionRate():
 *     Trainer t1 = new PersonalTrainer(...);
 *     Trainer t2 = new GroupTrainer(...);
 *     t1.getSessionRate(); // → 3000.0
 *     t2.getSessionRate(); // → 1000.0
 *
 *   Example 5 — MemberService.getMemberById() creating objects:
 *     // In MemberService.java:
 *     if ("PREMIUM".equals(type)) return new PremiumMember(...);
 *     else                        return new RegularMember(...);
 *     // The caller just gets a "Member" reference — doesn't know the subclass!
 *
 * WHY USEFUL:
 *   The servlet code NEVER needs to ask: "Are you Cash or Online?"
 *   It just calls payment.processPayment() — the RIGHT version runs.
 *   Adding a new payment type (CardPayment) only requires implementing
 *   processPayment() — no changes needed in the servlet!
 *
 * VIVA QUESTION: "Show me polymorphism in your project."
 * ANSWER: "In PaymentServlet.java, I call payment.processPayment().
 *          If the payment object is a CashPayment, it simply marks
 *          the status as PAID. But if it's an OnlinePayment, it
 *          first generates a unique TXN ID using UUID, then marks
 *          as PAID. The servlet code is identical — but the result
 *          is different based on the actual object type at runtime.
 *          That is runtime polymorphism through method overriding."
 *
 *
 * ============================================================
 * CONCEPT 4: ABSTRACTION
 * ============================================================
 *
 * DEFINITION:
 *   Hiding the complexity of HOW something is done.
 *   Defining WHAT must be done without specifying HOW.
 *   Two tools: abstract classes and interfaces.
 *
 * ABSTRACT CLASSES IN THIS PROJECT:
 *   - Person.java         — cannot instantiate, defines shared person identity
 *   - Member.java         — cannot instantiate, forces subclasses to define fees
 *   - Trainer.java        — cannot instantiate, forces subclasses to define rate
 *   - MembershipPlan.java — forces subclasses to define discount logic
 *   - Payment.java        — forces subclasses to define processPayment()
 *   - Review.java         — forces subclasses to define getDisplayBadge()
 *
 * INTERFACES IN THIS PROJECT:
 *   - Displayable    → getDisplayInfo(), getRole()
 *   - IPlanPriceable → calculatePrice(), calculateDiscountedPrice()
 *   - ISchedulable   → getAvailability(), isAvailable(String day)
 *   - IPayable       → processPayment(), generateReceipt()
 *   - IReportable    → generateReport(), getRecords()
 *   - IModerable     → approve(), remove(), getModerationStatus()
 *
 * CONCRETE EXAMPLE FROM THIS CODE:
 *   IPayable interface declares:
 *     boolean processPayment();   // WHAT to do — not HOW
 *     String generateReceipt();   // WHAT to do — not HOW
 *
 *   CashPayment implements IPayable:
 *     processPayment() { setStatus("PAID"); } // HOW for Cash
 *
 *   OnlinePayment implements IPayable:
 *     processPayment() {
 *         transactionId = UUID...;  // HOW for Online
 *         setStatus("PAID");
 *     }
 *
 *   PaymentServlet uses IPayable:
 *     IPayable payment = getPaymentFromForm(); // could be either type
 *     payment.processPayment(); // just calls the interface — doesn't know HOW
 *
 * WHY USEFUL:
 *   1. SIMPLICITY: PaymentServlet doesn't need to know the difference
 *      between Cash and Online. It just calls processPayment().
 *   2. EXTENSIBILITY: To add a CardPayment, just create a new class
 *      that implements IPayable. The servlet needs NO changes.
 *   3. DESIGN CONTRACT: IPayable guarantees that ANY payment type
 *      will have processPayment() and generateReceipt() available.
 *
 * VIVA QUESTION: "What is the difference between abstract class and interface?"
 * ANSWER:
 *   "An abstract class can have fields (data) and some implemented
 *    methods alongside abstract methods. For example, Payment.java
 *    has fields like amount and paymentDate with concrete getters,
 *    but processPayment() is abstract — each subclass implements it.
 *
 *    An interface has NO fields (only constants) and only method
 *    declarations. IPayable declares processPayment() without ANY code.
 *    It is a pure contract — it says 'any class that implements me
 *    MUST provide these methods.'
 *
 *    In this project, I use abstract classes when subclasses share
 *    common data (like Payment having amount, date). I use interfaces
 *    when I want to enforce capabilities across unrelated classes
 *    (Displayable is implemented by both Member and Trainer — they
 *    don't share a common parent besides Person, but both can display)."
 *
 *
 * ============================================================
 * QUICK REFERENCE — WHERE EACH CONCEPT IS DEMONSTRATED
 * ============================================================
 *
 * ENCAPSULATION:
 *   Member.java — private passwordHash with getter/setter
 *   Payment.java — private amount, method, status
 *
 * INHERITANCE:
 *   RegularMember → Member → Person (3-level)
 *   PersonalTrainer → Trainer → Person (3-level)
 *
 * POLYMORPHISM:
 *   MemberService.getMemberById() — returns RegularMember or PremiumMember
 *   PaymentServlet — calls payment.processPayment() (Cash or Online)
 *   ReviewServlet  — creates PublicReview or VerifiedReview
 *   plans.jsp      — calls plan.calculateDiscountedPrice() on Short or Long term
 *
 * ABSTRACTION:
 *   Abstract classes: Person, Member, Trainer, MembershipPlan, Payment, Review
 *   Interfaces: Displayable, IPlanPriceable, ISchedulable, IPayable, IReportable, IModerable
 *
 * ============================================================
 */
public class OOP_CONCEPTS {
    // This class exists ONLY as documentation.
    // There is no code here — only the comments above.
    // Read the Javadoc comment block above for your viva preparation.
}
