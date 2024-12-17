# 🗄 Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.3] - 2024-12-17

- Search region by its name: `Municipitaly::Search.province_from_name('a province')`
- Fixed and tested specs

## [2.0.2] - 2024-12-13

- Added `csv` to spec as advised for ruby `3.4.0` onward

## [2.0.1] - 2024-12-09

- Updated database
- Added `area`, `supcode` and `kind` to provinces

## [2.0.0] - 2024-07-25

### Changed

- Renamed the fork to `municipitaly2`
- Bumped version to 2.0.0

## [0.5.0] - 2024-06-20 (forked by yupswing)

### Added

- Fixed search provinces or municipalities with diacritics
- Updated database 27-05-2024 (population data as 2021)\
- Municipalities `latitude`, `longitude` and `area` (km2)

## [0.4.0] - 2020-11-18

### Added

- Search province by its name: `Municipitaly::Search.province_from_name('a province')`

## [0.3.0] - 2020-02-27

### Added

- ISO 3166-2 code in region object `#iso3166_2` or alias `#iso3166`

## [0.2.0] - 2020-02-24

### Added

- ISO 3166-2 code in province object `#iso3166_2` or alias `#iso3166`

## [0.1.0] - 2020-02-13

### Changed

- Update municipalities data according to latest ISTAT changes (jan 2020)

## [0.0.3] - 2020-02-10

### Added

- The optional parameter _greedy_ in `Municipitaly::Search.municipalities_from_name`
