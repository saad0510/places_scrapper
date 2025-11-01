<img src="https://raw.githubusercontent.com/saad0510/places_scrapper/main/doc/cover.png" />

# Places Scrapper

A website to showcase my solution strategy used in [NokNokAI](https://noknokai.com) to escape the limitations of Google Places API and scrape businesses from a large geo-region, like a city.

- 🗾 Create boundaries of different region.
- 🪓 Simplify each region to save space.
- 💎 Fill regions with a grid of hexagonal cells.
- 🔍 Search for Google Places in each cell.
- 🚗 Group nearby places together in a visit route.

## Background

It is a limited version of the original platform and includes random data for illustration purposes only.

## Links

⚡ Website : [Click here](https://saad0510.github.io/places_scrapper) <br>
💻 Platform : [Click here](https://noknokai.com/) <br>
📽️ Video : [Click here](https://drive.google.com/file/d/1WU50BeynBNDoaCU2IGifww770nGkzUjC/view?usp=drive_link) <br>

## [NokNokAI](https://noknokai.com)

A web CRM that connects users to nearby businesses and potential leads. It shows city-wide businesses on Google Maps and generates optimized visit routes for salespeople.

## Challenges

Apparently, all you need is a call to Google Maps Places API to search for nearby businesses. However, the request is limited to only 20 results. Even with paginated responses, you cannot exceed 60 results. Furthermore, the Direction API supports a maximum of 25 stops per route, so the route grouping algorithm has to be customized.

## Solution

The solution involves designing an automated workflow that runs in the cloud, scraps information, and updates the database continuously. In short: restrict the search region, tile it into a grid of small cells, query Places API in each cell, recursively refine dense areas, and group businesses into routes while deduplicating aggressively so we do not waste calls and storage.

## Workflow

### 1. Geo-Regions

The process starts with restricting the search area to the city of the user. I used Geoapify API to get an outline and boundary definition of the search space. Each new location triggers an API which creates a “geo-region” object in the database, storing a list of coordinates.

### 2. Simplification of Geo-Regions

The Polygon API returns an unnecessarily long list of coordinates, but we only need the bare minimum points required to define outlines. Therefore, I used the "Concave Hull" algorithm to reduce the number of coordinates and saved up-to 80% of storage space.

### 3. Grid Cells
The idea is to fill the region with a grid of small cells and query the Places API in each of them. I experimented with circular cells but they were simply inaccurate with gaps, overlaps, and inconsistency at different latitudes, especially around the poles.


After a lot of struggle, I got inspiration from a medium article which solved this problem using the “Geospatial Hexagonal Indexing System” (h3geo.org) developed by Uber engineers. I used it to create symmetric, discrete, and unique hexagonal grids which perfectly covered the whole region.

### 4. Scrapper

Whenever a new cell is created, a task is enqueued in a cloud queue to call the Places API. If a maximum number of results are returned, the parent cell recursively spawns finer cells to capture missing spots near edges of the hexagon and collect every single business in the area.

The Cloud Task queue also manages the throughput of the system in order to stay within the rate limitations of Google APIs. It also defines an error handling policy to retry failed tasks.

### 5.   Routing Algorithm

After ingestion, new businesses are clustered together into routes to keep visit stops geographically close for the sales person. Since the Directions API supports a maximum of 25 stops per request, I had to design my own Breadth-First-Search algorithm to limit group size and search radius. The algorithm runs only on fresh points to avoid recomputing everything.

## Developer
saadbinkhalid.dev@gmail.com
