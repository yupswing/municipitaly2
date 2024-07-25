# 🇮🇹 Municipitaly2

[![Gem Version](https://badge.fury.io/rb/municipitaly2.svg)](https://badge.fury.io/rb/municipitaly2)

This gem provide various data about 🇮🇹 Italian subdivisions and municipalities. As well the entire updated list of provinces, regions and municipalities names, it provide useful codes (📯 postal code(s), 🌐 [ISTAT](https://www.istat.it/en/) codes, cadastrial code, population, ...).

## ℹ️️ Informations

This gem is a continuation of [Municipitaly by natydev](https://github.com/natydev/municipitaly).
Database is updated up to May 2024 and there are improvements to search.
Thanks to natydev for the brilliant project.

## 💾 Installation

Add this line to your application's Gemfile:

```ruby
gem 'municipitaly2', git: 'https://github.com/yupswing/municipitaly2.git', branch: 'master'
```

And then execute:

    $ bundle

## 👁 Scenic

These entities are present, subpoints are data attributes:

- **Zone** - NUTS 1 (it: _Zona/Ripartizione geografica_)
  - name
  - code (it: _codice zona_)
- **Region** - NUTS 2 (it: _Regione_)
  - name
  - ISTAT code (it: _codice istat_)
- **Province** - NUTS 3 (it: _Provincia_)
  - name
  - ISTAT code (it: _codice istat_)
  - acronym (it: _sigla_)
- **Municipality** (it: _Comune_)
  - name
  - name_alt (alternative name)
  - name_full (composite of name + name_alt if present)
  - ISTAT code (it: _codice istat_)
  - cadastrial code (it: _codice catastale_)
  - postal code(s) (it: _codice/i postale/i_)
  - population
  - area (square km)
  - latitude
  - longitude

## 🛠 Usage and examples

The **Municipitaly2::Search** is the principal class used to search entities.  
Returned data are stored in 4 different types of entity models:

- **Municipitaly2::Zone**
- **Municipitaly2::Region**
- **Municipitaly2::Province**
- **Municipitaly2::Municipality**

Retrieve all zones (return an array of `Municipitaly2::Zone` objects):

```ruby
# inside an irb or rails console:
require 'municipitaly2'

zones = Municipitaly2::Zone.all
# => [#<Municipitaly2::Zone:0x0000...]
```

pick a random zone:

```ruby
zone = zones.sample
# => #<Municipitaly2::Zone:0x00007fb8390b9f48 @name="Centro", @code="3">
```

retrive data zone:

```ruby
zone.name
# => "Centro"

zone.code
# => "3"
```

all regions belongs to a zone (return an array of `Municipitaly2::Region` objects):

```ruby
zone.regions
# => [#<Municipitaly2::Region:0x00007fb83883c550...]
```

and so for other entities:

```ruby
zone.provinces
# => [#<Municipitaly2::Province:0x00007fb83a1478...]

zone.municipalities
# => [#<Municipitaly2::Municipality:0x00007fb83a...]
```

### 🔎 Search

**Municipitaly2::Search** is the most useful and interesting class: with that you can search single or multiple entities by the name, code or other attributes.

Search municipalities **from its name**: is case insensitive and can be partial (it returns an Array):

```ruby
municipalities = Municipitaly2::Search.municipalities_from_name('ricco')
# => [#<Municipitaly2::Municipality:0x00007d6f8c10e428
#       @area=26.2065,
#       @cadastrial_code="I640",
#       @latitude=44.5078406,
#       @longitude=8.936045,
#       @name="Serra Riccò",
#       @partial_istat="058",
#       @population=7615,
#       @postal_codes=["16010"],
#       @province_istat="010">,
#     #<Municipitaly2::Municipality:0x00007d6f8c106048
#       @area=37.7634,
#       @cadastrial_code="H275",
#       @latitude=44.1555442,
#       @longitude=9.7634234,
#       @name="Riccò del Golfo di Spezia",
#       @partial_istat="023",
#       @population=3615,
#       @postal_codes=["19020"],
#       @province_istat="011">,
#     #<Municipitaly2::Municipality:0x00007d6f8c233a38
#       @area=20.3924,
#       @cadastrial_code="B031",
#       @latitude=45.5328242,
#       @longitude=11.9685041,
#       @name="Borgoricco",
#       @partial_istat="013",
#       @population=8906,
#       @postal_codes=["35010"],
#       @province_istat="028">]

municipality = municipalities.first
# => #<Municipitaly2::Municipality:0x00007fb83918483..>

municipality.name
# => "Serra Riccò"

municipality.postal_codes
# => ["16010"]
```

from an entity object is possible to retrieve other parent objects and its attributes:

```ruby
municipality.province_name
# => "Padova"

municipality.province_acronym
# => "PD"

municipality.province
# => #<Municipitaly2::Province:0x00007fb83a12701...>

municipality.region_name
# => "Veneto"

municipality.region
# => #<Municipitaly2::Region:0x00007fb83883cf28...>

municipality.zone
# => #<Municipitaly2::Zone:0x00007fb8390bb938...>
```

or retrieve nested entities:

```ruby
padua = municipality.province
# => #<Municipitaly2::Province:0x00007fb83a127010...>

padua.municipalities
# => [#<Municipitaly2::Municipality:0x00007fb83915b730...]
```

Search municipalities **from a single postal code**:

```ruby
municipalities = Municipitaly2::Search.municipalities_from_postal_code('50145')
# => [#<Municipitaly2::Municipality:0x00007fb83a295938 @province_istat="048", @name="Firenze"...]

florence = municipalities.first
# => #<Municipitaly2::Municipality:0x00007fb83a295938...>

florence.postal_codes
#  => ["50121", "50122", "50123", "50124", "50125", "50126", "50127", "50128", "50129", "50130", "50131", "50132", "50133", "50134", "50135", "50136", "50137", "50138", "50139", "50140", "50141", "50142", "50143", "50144", "50145"]
```

Complete list of available class and instance methods are documented inside code, is suggested to use `rdoc`, read at next point.

### 📖 Rdoc

Clone locally this repository and run
`bundle exec rdoc` to produce complete documentation inside your local directory.

## 🗄 Changelog

Complete list in [this section](CHANGELOG.md)

## 🤝 Contributing

Fells free to improve or suggest new features/ideas.
Bug reports and pull requests are welcome on GitHub at https://github.com/yupswing/municipitaly2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

If you want to contribute keep these guidelines in mind:

- Despite is an Italy focused gem, I accept only PR, issues and messages **in English** lang.
- Code must be well formatted and **offences free**, use the provided `rubocop` gem.
- Use the same **coding conventions** as the rest of the project.
- Code must be **tested** (with rspec).
- Write code according to **SOLID** Principles.

Steps to submit your code:

1. Fork the repo.
2. Open your feature/namespaced branch
3. Commit your code following Github guidelines.
4. Make a PR with an exhaustive description.

## 📃 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Data sources

- [Database dei comuni italiani by Garda Informatica](https://www.gardainformatica.it/database-comuni-italiani) (MIT Licence)
- [Dati censimento 2021 - Ministero dell'Interno](https://dait.interno.gov.it/territorio-e-autonomie-locali/sut/elenco_cens_var_comuni_italiani.php) (Public)

# Useful info

## Build gem

`gem build municipitaly2.gemspec`

## Check specs

`bundle exec rspec`

## Update database

Check the `tools` folder.
The tool is rought but it gets the job done. Hopefully I will improve it in the future.
