"
I represent a weather forecast object. I provide methods for constructing and executing a query to the Open-Meteo Weather API and inspecting the query results as a table.

## Example

Evaluate and inspect the following to render a table view of the weather forecast.

```lang=pharo
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

"
Class {
	#name : 'TlalocForecast',
	#superclass : 'PBArray2D',
	#instVars : [
		'latitude',
		'longitude',
		'hourlyParameters',
		'temperatureUnit',
		'windSpeedUnit',
		'precipitationUnit',
		'timezone',
		'queryResult',
		'forecastDays'
	],
	#category : 'Tlaloc-Objects',
	#package : 'Tlaloc',
	#tag : 'Objects'
}

{ #category : 'accessing' }
TlalocForecast >> apiQuery [
	"returns an API query as URL-formatted string"

	^ self openMeteoAPI , '?' , self endpoints
]

{ #category : 'scripting api - executing' }
TlalocForecast >> call [
	"Execute an API call for a given API query and tabulate the result"

	queryResult := self apiQuery asZnUrl retrieveContents.
	self tabulateQueryResult
]

{ #category : 'accessing' }
TlalocForecast >> endpoints [
	"returns the endpoints as a string to be appended to an API for constructing an API query. See https://open-meteo.com/en/docs#api_documentation"

	| endpointsAsOrderedDict endpointsAsOrderedCollection |
	endpointsAsOrderedDict := OrderedDictionary new.
	latitude ifNotNil: [ endpointsAsOrderedDict at: 'latitude' put: latitude ].
	longitude ifNotNil: [ endpointsAsOrderedDict at: 'longitude' put: longitude ].
	hourlyParameters ifNotEmpty: [ endpointsAsOrderedDict at: 'hourly' put: (',' join: hourlyParameters) ].
	temperatureUnit ifNotNil: [ endpointsAsOrderedDict at: 'temperature_unit' put: temperatureUnit ].
	windSpeedUnit ifNotNil: [ endpointsAsOrderedDict at: 'wind_speed_unit' put: windSpeedUnit ].
	precipitationUnit ifNotNil: [ endpointsAsOrderedDict at: 'precipitation_unit' put: precipitationUnit ].
	forecastDays ifNotNil: [ endpointsAsOrderedDict at: 'forecast_days' put: forecastDays ].
	timezone ifNotNil: [ endpointsAsOrderedDict at: 'timezone' put: timezone ].

	endpointsAsOrderedCollection := endpointsAsOrderedDict keys collect: [ :key |
		                                key , '=' , (endpointsAsOrderedDict at: key) asString ].
	^ '&' join: endpointsAsOrderedCollection
]

{ #category : 'accessing' }
TlalocForecast >> forecastDays: numberOfDaysAsInteger [

	forecastDays := numberOfDaysAsInteger
]

{ #category : 'accessing' }
TlalocForecast >> hourlyParameters: anArrayOfHourlyParameters [
	"See https://open-meteo.com/en/docs#hourly_parameter_definition"

	hourlyParameters := anArrayOfHourlyParameters
]

{ #category : 'inspector extensions' }
TlalocForecast >> inspectionTable: specBuilder [

	<inspectorPresentationOrder: 10 title: 'Forecast'>
	^ super inspectionTable: specBuilder
]

{ #category : 'setter' }
TlalocForecast >> latitude: aLatitudeAsInteger longitude: aLongitudeAsInteger [

	latitude := aLatitudeAsInteger.
	longitude := aLongitudeAsInteger
]

{ #category : 'accessing' }
TlalocForecast >> openMeteoAPI [
	"returns open-meteo API as URL-formatted string"

	^ 'https://api.open-meteo.com/v1/forecast'
]

{ #category : 'setter' }
TlalocForecast >> precipitationUnit: aPrecipitationUnitString [

	precipitationUnit := aPrecipitationUnitString
]

{ #category : 'operations' }
TlalocForecast >> tabulateQueryResult [
	"Tabulate the result returned from executing the API query"

	| parsedQueryResult hourly hourly_units rows columns |
	parsedQueryResult := STONJSON fromString: queryResult.
	hourly := parsedQueryResult at: 'hourly'.
	hourly_units := parsedQueryResult at: 'hourly_units'.
	rows := (hourly at: 'time') size.
	columns := hourly size + 1.
	columnNames := { 'date' } , { 'time' } , hourlyParameters.
	self
		rows: rows
		columns: columns
		tabulate: [ :row :column |
				| columnName cellValue |
				columnName := columnNames at: column.
				columnName = 'date'
					ifTrue: [
							cellValue := hourly at: 'time' at: row.
							cellValue asDate ]
					ifFalse: [
							cellValue := hourly at: columnName at: row.
							columnName = 'time'
								ifTrue: [ cellValue asDateAndTime asTime asString ]
								ifFalse: [ cellValue ] ] ]
		columnNames: (columnNames collect: [ :key |
					 key = 'date'
						 ifTrue: [ key ]
						 ifFalse: [
								 key = 'time'
									 ifTrue: [ key , ' (' , timezone , ')' ]
									 ifFalse: [ key , ' (' , (hourly_units at: key) , ')' ] ] ])
]

{ #category : 'setter' }
TlalocForecast >> temperatureUnit: aTemperatureUnitAsString [

	temperatureUnit := aTemperatureUnitAsString
]

{ #category : 'setter' }
TlalocForecast >> timezone: aTimezoneAsString [

	timezone := aTimezoneAsString
]

{ #category : 'setter' }
TlalocForecast >> windSpeedUnit: aWindSpeedUnitAsString [

	windSpeedUnit := aWindSpeedUnitAsString
]
