# OpenWeatherData

This is the Devmountain iOS App Developer Bootcamp exercise Build Your Own App - API app.

The app fetches weather data from the OpenWeather API (https://openweathermap.org/api) and displays the current-conditions and 7-day forecast.

Locations can be entered using an address or GPS coordinates. If an address is used, CLGeoder is used to obtain the latitude and longitude which is required by the OpenWeather API.

The views are created programmatically: Interface Builder isn't used.

A custom URLSessionConfiguration is used to force weather data to always be downloaded instead of being read from cache.

The API key is stored in a .plist file that is not included in the repo. A sample.plist file is included in the repo, but not the build target, and is coied to the required .plist file using a build phase _run script_ if it doesn't exist. (This approach is modeled after https://peterfriese.dev/posts/reading-api-keys-from-plist-files/.)

### Technoloy

Swift, UIKit, CoreLocation, URLSession
