package com.example.campus_clubs;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "java/bestTimes";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // This method is invoked on the main thread.
                            if (call.method.equals("runMain")) {
                                String timeslot = runMain();

                                if (timeslot != null) {
                                    result.success(timeslot);
                                } else {
                                    result.error("UNAVAILABLE", "Unable to call java method.", null);
                                }
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    public static String runMain() {
//        final String FILEPATH = "input.txt";

//        ArrayList<String> fileData = getFileData(FILEPATH);
//        ArrayList<Timeslot> timeslotData = toTimeslots(fileData);
        ArrayList<ArrayList<Integer>> schedule = createNewSchedule();
//        schedule = addTimes(schedule, timeslotData);

        // Sample data TODO: Replace with firestore data
        Random r = new Random();
        for (int i = 0; i < 7; i++) {
            for (int j = 0; j < 73; j++) {
                schedule.get(i).set(j, r.nextInt(50));
            }
        }

        char c = 'M'; // TODO: Replace with selector
        int index;
        switch (c) {
            case 'M': index = 1;
                break;
            case 'T': index = 2;
                break;
            case 'W': index = 3;
                break;
            case 'R': index = 4;
                break;
            case 'F': index = 5;
                break;
            default: index = 0;
        }
        ArrayList<Timeslot> bestTimes = getBestTimes(schedule.get(index), c);

        return bestTimes.get(0).toString();
    }

    // Gets schedule times from txt and loads into array
    public static ArrayList<String> getFileData(String filename) {
        File file = new File(filename);
        ArrayList<String> fileData = new ArrayList<>();
        try {
            Scanner s = new Scanner(file);
            while (s.hasNextLine()) {
                String line = s.nextLine();
                int i = 0;
                while (line.charAt(i) != ' ') {
                    fileData.add(removeLetters(line, line.charAt(i)));
                    i++;
                }
            }
        } catch (IOException e) {
//            System.err.println("File not found: " + filename);
        }
        return fileData;
    }

    public static String removeLetters(String line, char x) {
        Scanner s = new Scanner(line);
        String token = s.next();
        token = s.next();
        return x + " " + token;
    }

    // String to timeslot object
    public static ArrayList<Timeslot> toTimeslots(ArrayList<String> fileData) {
        ArrayList<Timeslot> timeslotData = new ArrayList<>();
        for (String s : fileData) {
            timeslotData.add(new Timeslot(s));
        }
        return timeslotData;
    }

    // Create schedule [Sunday - Saturday][6:00 - 0:00] (broken up every 15 min)]
    public static ArrayList<ArrayList<Integer>> createNewSchedule() {
        ArrayList<ArrayList<Integer>> schedule = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            ArrayList<Integer> times = new ArrayList<>();
            for (int j = 0; j < 73; j++) {
                times.add(0);
            }
            schedule.add(times);
        }
        return schedule;
    }

    // Add timeslots to schedule
    public static ArrayList<ArrayList<Integer>> addTimes(ArrayList<ArrayList<Integer>> schedule, ArrayList<Timeslot> timeslotData) {
        for (Timeslot ts : timeslotData) {
            for (int i = getIndex(ts.hours1, ts.minutes1); i <= getIndex(ts.hours2, ts.minutes2); i++) {
                int temp;
                switch (ts.day) {
                    case 'M':
                        temp = schedule.get(1).get(i);
                        schedule.get(1).set(i, temp + 1);
                        break;
                    case 'T':
                        temp = schedule.get(2).get(i);
                        schedule.get(2).set(i, temp + 1);
                        break;
                    case 'W':
                        temp = schedule.get(3).get(i);
                        schedule.get(3).set(i, temp + 1);
                        break;
                    case 'R':
                        temp = schedule.get(4).get(i);
                        schedule.get(4).set(i, temp + 1);
                        break;
                    case 'F':
                        temp = schedule.get(5).get(i);
                        schedule.get(5).set(i, temp + 1);
                        break;
                    default:
//                        System.err.println("Invalid day: " + ts.day);
                        break;
                }
            }
        }
        return schedule;
    }

    public static int getIndex(int hours, int minutes) {
        int result = (hours - 6) * 4;
        result += minutes / 15;
        return result;
    }

    // Iterate to find the lowest sum in window
    public static ArrayList<Timeslot> getBestTimes(ArrayList<Integer> a, char day) {
        ArrayList<Timeslot> bestTimeslots = new ArrayList<>();

        if (a.size() < 4) {
            return bestTimeslots;
        } else if (a.size() == 4) {
            bestTimeslots.add(new Timeslot(day + " 06:00-07:00"));
            return bestTimeslots;
        }

        int window = a.get(0) + a.get(1) + a.get(2) + a.get(3);
        int min = window;
        for (int i = 1; i < a.size() - 3; i++) {
            window -= a.get(i - 1);
            window += a.get(i + 3);
            if (window < min) {
                min = window;
            }
        }

        window = a.get(0) + a.get(1) + a.get(2) + a.get(3);
        if (window == min) {
            bestTimeslots.add(new Timeslot(day + " 06:00-07:00"));
        }
        for (int i = 1; i < a.size() - 3; i++) {
            window -= a.get(i - 1);
            window += a.get(i + 3);
            if (window == min) {
                String temp = day + " " + getTime(i);
                bestTimeslots.add(new Timeslot(temp));
            }
        }
//        bestTimeslots.removeLast();
        return bestTimeslots;
    }

    public static String getTime(int index) {
        String str = "";
        int hours = index / 4 + 6;
        int minutes;
        switch (index % 4) {
            case 1: minutes = 15;
                break;
            case 2: minutes = 30;
                break;
            case 3: minutes = 45;
                break;
            default: minutes = 0;
                break;
        }
        if (hours < 10) {
            str += "0" + hours;
        } else {
            str += hours;
        }
        if (minutes < 10) {
            str += ":0" + minutes;
        } else {
            str += ":" + minutes;
        }
        str += "-";

        hours++;
        if (hours < 10) {
            str += "0" + hours;
        } else {
            str += hours;
        }
        if (minutes < 10) {
            str += ":0" + minutes;
        } else {
            str += ":" + minutes;
        }
        return str;
    }
}