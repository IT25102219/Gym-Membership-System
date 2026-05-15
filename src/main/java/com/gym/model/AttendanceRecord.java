package com.gym.model;

import com.gym.interfaces.Displayable;
import com.gym.interfaces.IReportable;

import java.util.ArrayList;
import java.util.List;

public class AttendanceRecord implements IReportable, Displayable {

    private int recordId;
    private int memberId;
    private String memberName;
    private String checkIn;
    private String checkOut;
    private String attendDate;

    public AttendanceRecord(int recordId, int memberId, String memberName,
                            String checkIn, String checkOut, String attendDate) {
        this.recordId = recordId;
        this.memberId = memberId;
        this.memberName = memberName;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.attendDate = attendDate;
    }

    public AttendanceRecord() {}

    public double calculateDuration() {
        if (checkOut == null || checkOut.isEmpty() || checkOut.equals("null")) {
            return 0.0;
        }

        try {
            String[] checkInParts = checkIn.split(" ");
            String[] checkOutParts = checkOut.split(" ");

            String checkInTime  = checkInParts.length > 1  ? checkInParts[1]  : "00:00:00";
            String checkOutTime = checkOutParts.length > 1 ? checkOutParts[1] : "00:00:00";

            String[] inParts  = checkInTime.split(":");
            String[] outParts = checkOutTime.split(":");

            int inMinutes  = Integer.parseInt(inParts[0])  * 60 + Integer.parseInt(inParts[1]);
            int outMinutes = Integer.parseInt(outParts[0]) * 60 + Integer.parseInt(outParts[1]);

            int diffMinutes = outMinutes - inMinutes;

            if (diffMinutes < 0) {
                diffMinutes += 24 * 60; 
            }

            return Math.round((diffMinutes / 60.0) * 10.0) / 10.0;

        } catch (Exception e) {
            return 0.0;
        }
    }

    @Override
    public String generateReport() {
        // Build the report string with all key attendance information
        String duration = checkOut == null || checkOut.isEmpty()
            ? "Still inside"
            : calculateDuration() + " hrs";

        return "Member: " + memberName +
               " | Date: " + attendDate +
               " | Check-in: " + (checkIn != null ? checkIn : "N/A") +
               " | Check-out: " + (checkOut != null ? checkOut : "Still inside") +
               " | Duration: " + duration;
    }

    @Override
    public List<AttendanceRecord> getRecords() {
        // Wrap this single record in a list to satisfy the IReportable interface
        List<AttendanceRecord> list = new ArrayList<>();
        list.add(this);
        return list;
    }

    @Override
    public String getDisplayInfo() {
        String outTime = (checkOut == null || checkOut.isEmpty())
            ? "Still inside"
            : checkOut;

        return "Member: " + memberName +
               " | Date: " + attendDate +
               " | In: " + checkIn +
               " | Out: " + outTime;
    }

    @Override
    public String getRole() {
        return "ATTENDANCE_RECORD";
    }

    public int getRecordId() { return recordId; }
    public int getMemberId() { return memberId; }
    public String getMemberName() { return memberName; }
    public String getCheckIn() { return checkIn; }
    public String getCheckOut() { return checkOut; }
    public String getAttendDate() { return attendDate; }

    public void setRecordId(int recordId) { this.recordId = recordId; }
    public void setMemberId(int memberId) { this.memberId = memberId; }
    public void setMemberName(String memberName) { this.memberName = memberName; }
    public void setCheckIn(String checkIn) { this.checkIn = checkIn; }
    public void setCheckOut(String checkOut) { this.checkOut = checkOut; }
    public void setAttendDate(String attendDate) { this.attendDate = attendDate; }

    @Override
    public String toString() {
        return "AttendanceRecord{id=" + recordId + ", member='" + memberName +
               "', date='" + attendDate + "', in='" + checkIn + "', out='" + checkOut + "'}";
    }
}
