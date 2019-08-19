package com.pathcare.pathprovider.util;

import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Component;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateConverters {

    private static DateTimeFormatter formatterHyphenSeparated = DateTimeFormat.forPattern("yyyy-MM-dd");

    public String formatNullDateTime(Date dateOrNull) {
        return (dateOrNull == null ? "" : DateFormat.getDateTimeInstance().format(dateOrNull));
    }


    public static String convertDateToStringDashFormat(Date date) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        return formatter.format(date);
    }

    public static LocalDate convertStringToDateDashFormat(String strDate) {
        if (strDate == null || strDate.trim().isEmpty()) {
            return null;
        }

        LocalDate localDate = LocalDate.parse(strDate, formatterHyphenSeparated);
        return localDate != null ? localDate : null;
    }


    public static LocalDate convertStringToDate(String strDate, String datePattern) {
        DateTimeFormatter df = DateTimeFormat.forPattern(datePattern);
        if (strDate == null || strDate.trim().isEmpty()) {
            return null;
        }
        return df.parseLocalDate(strDate);
    }


    /**
     * Convert from Date to string with Date and Time
     *
     * @param date the date
     * @return the formatted string date
     */
    public static String convertDateToDateTimeStringDashFormat(Date date) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return formatter.format(date);
    }

    /**
     * Convert from Date to string with Date and Time
     *
     * @param date the date
     * @return the formatted string date
     */
    public static String convertDateToDateTimeStringNoSecondFormat(Date date) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        return formatter.format(date);
    }
}
