# FloraExam

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**FloraExam** is an R package built with the [{golem} framework](https://thinkr-open.github.io/golem/) that provides a Shiny application to explore, score, and visualize Danish flora and vegetation types. This repository hosts both the code for the **FloraExam** R package and the Docker configuration that allows seamless deployment. 

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Running the App](#running-the-app)
  - [Local R Installation](#local-r-installation)
  - [Docker Installation](#docker-installation)
- [Data Sources](#data-sources)
- [Dependencies](#dependencies)
  - [artscore Package](#artscore-package)
- [Live Demo](#live-demo)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

---

## Overview

**FloraExam** is designed to help students:

- Examine flora data with user-friendly Shiny dashboards.
- Utilize ecological scoring systems (e.g., CSR values, Ellenberg indicator values).
- Assess species frequency and spatial information.

This application leverages multiple datasets and the companion [**Artscore** package](https://github.com/Sustainscapes/Artscore) to provide integrated analysis and visualization tools. 

**Note**: A public instance of this app is available at [DanishVegetationTypes](https://danish-flora-and-vegetation.github.io/DanishVegetationTypes.html).

---

## Features

1. **Interactive Shiny App**: Built using `{golem}` for modular and maintainable Shiny code.
2. **Ecological Scoring**: Integrates Ellenberg and CSR values for species analysis.
3. **Frequency and Spatial Data**: Includes frequency data and spatial distributions of species.
4. **Easy Deployment**: Automated Docker builds for easy deployment on Azure or any other containerized environment.

---

## Installation

You can install **FloraExam** from GitHub. Before installing, ensure you have the [**remotes**](https://github.com/r-lib/remotes) package installed.

```r
# install.packages("remotes") # If not already installed

# Install FloraExam directly from GitHub
remotes::install_github("Sustainscapes/FloraExam")
```

This will also install the **FloraExam** R package dependencies automatically.

---

## Running the App

### Local R Installation

Once **FloraExam** is installed, you can launch the Shiny app locally:

```r
library(FloraExam)
run_app()
```

The app will open in your default web browser.

### Docker Installation

This repository includes a **Dockerfile** that is automatically rebuilt on every push to GitHub. To run **FloraExam** via Docker:

1. Clone this repository or pull the public image (if available).
2. Build the Docker image:

   ```bash
   docker build -t floraexam .
   ```

3. Run the Docker container:

   ```bash
   docker run --rm -p 3838:3838 floraexam
   ```

4. Open your web browser at [http://localhost:3838](http://localhost:3838) to access the app.

---

## Data Sources

**FloraExam** relies on several data sources for its functionality:

1. **Ellenberg_CSR dataset**  
   - [NewCSRValues](https://github.com/Sustainscapes/NewCSRValues)  
   - [NewEllembergValues](https://github.com/Sustainscapes/NewEllembergValues)

2. **Final_Frequency and SpatialData datasets**  
   - [SpeciesAndHabitatFrequency](https://github.com/Sustainscapes/SpeciesAndHabitatFrequency)

3. **artscore**  
   - [Artscore](https://github.com/Sustainscapes/Artscore) provides scoring functions for ecological analyses used within **FloraExam**.

These datasets and the **artscore** package are automatically installed or fetched when you install and run **FloraExam** (provided you have internet access).

---

## Dependencies

The main additional dependency used by **FloraExam** is:

- [**Artscore**](https://github.com/Sustainscapes/Artscore): An R package for ecological scoring and analysis.

All other dependencies (R packages) can be found in the `DESCRIPTION` file within this repo.

### artscore Package

The **artscore** package is developed by [Sustainscapes](https://github.com/Sustainscapes/Artscore). It includes key functions for calculating ecological indices, scoring species, and more. **FloraExam** integrates with **artscore** to enhance your ecological analysis workflow.

---

## Live Demo

A live version of **FloraExam** is hosted at:  
[**DanishVegetationTypes**](https://danish-flora-and-vegetation.github.io/DanishVegetationTypes.html)

Feel free to explore and interact with the app to see what **FloraExam** can do!

---

## Contributing

We welcome contributions to improve **FloraExam**. Here’s how you can help:

1. **Fork** the repository on GitHub.
2. **Create a new branch** for your changes.
3. **Commit and push** your changes to your branch.
4. **Submit a Pull Request** describing your changes.

Please ensure your code meets our style guidelines and includes unit tests where necessary.

---

## License

This project is licensed under the terms of the [MIT License](LICENSE). You are free to use, modify, and distribute this software.

---

## Acknowledgments

We extend our thanks to all contributors and the open-source community who make projects like **FloraExam** possible. Special thanks to:

- [Sustainscapes](https://github.com/Sustainscapes) for developing **FloraExam** and the **artscore** package.  
- The authors and maintainers of the various data repositories integrated into **FloraExam**.

For any questions or issues, please [open an issue](https://github.com/Sustainscapes/FloraExam/issues) or contact us directly.



Happy exploring and analyzing Danish flora and vegetation!
---
