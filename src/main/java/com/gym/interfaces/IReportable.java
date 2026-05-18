package com.gym.interfaces;

import com.gym.model.AttendanceRecord;
import java.util.List;

public interface IReportable {
    String generateReport();
    List<AttendanceRecord> getRecords();
}
