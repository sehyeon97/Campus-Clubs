package com.example.campus_clubs;

public class Timeslot {
    public char day;
    public int hours1;
    public int hours2;
    public int minutes1;
    public int minutes2;

    public Timeslot(char day, int hours1, int minutes1, int hours2, int minutes2) {
        this.day = day;
        this.hours1 = hours1;
        this.minutes1 = minutes1;
        this.hours2 = hours2;
        this.minutes2 = minutes2;
    }

    public Timeslot(String str) {
        day = str.charAt(0);
        hours1 = Integer.parseInt(str.substring(2, 4));
        minutes1 = Integer.parseInt(str.substring(5, 7));
        hours2 = Integer.parseInt(str.substring(8, 10));
        minutes2 = Integer.parseInt(str.substring(11, 13));
        if (str.length() > 13) {
            if (str.substring(13).equals("PM")) {
                if (hours1 != 12) hours1 += 12;
                if (hours2 != 12) hours2 += 12;
            }
        }
    }

    @Override
    public String toString() {
        String time = day + " ";

        if (hours1 < 10) {
            time += "0" + hours1;
        } else {
            time += hours1;
        }

        if (minutes1 < 10) {
            time += ":0" + minutes1;
        } else {
            time += ":" + minutes1;
        }

        if (hours2 < 10) {
            time += "-0" + hours2;
        } else {
            time += "-" + hours2;
        }

        if (minutes2 < 10) {
            time += ":0" + minutes2;
        } else {
            time += ":" + minutes2;
        }

        return time;
    }
}
