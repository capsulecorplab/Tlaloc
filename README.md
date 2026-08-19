# Tlaloc

A Pharo/Smalltalk library for querying and presenting weather data using the [Open-Meteo Weather API](https://github.com/open-meteo/open-meteo)

## Requirements

- [Pharo](https://pharo.org/download) (13+ recommended)

## Loading instructions

To load the latest development branch, open a playground window (`Ctrl+O+W`) and evaluate:

```smalltalk
Metacello new baseline: 'Tlaloc';
    repository: 'github://capsulecorplab/Tlaloc:main/src';
    load.
```

NOTE: Evaluate by highlighting the code, then either right-click on the highlighted code and click `Do it` or press `Ctrl+D`.

## Example

In a playground window, evaluate and inspect (`Ctrl+G`) the following code snippet to execute an API query for a 16 day weather forecast and view the results in a table view.

```smalltalk
TlalocForecast new
        latitude: 19.434629048156545 longitude: -99.13188352837948;
        hourlyParameters: { 'temperature_2m'. 'relative_humidity_2m'. 'wind_speed_10m'. 'precipitation' };
        temperatureUnit: 'fahrenheit';
        windSpeedUnit: 'mph';
        precipitationUnit: 'inch';
        timezone: 'CST';
        forecastDays: 16;
        call
```

## Etymology

[Tlaloc](https://en.wikipedia.org/wiki/Tl%C3%A1loc) is the Aztec god of rain.
