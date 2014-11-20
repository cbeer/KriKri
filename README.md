Kri-Kri
=======

A Rails engine for metadata aggregation, enhancement, and quality control.

Installation
-------------

Add `krikri` to your Gemfile.  Kri-Kri will mount automatically by editing your 
application's `config/routes.rb` to include:

    mount Krikri::Engine => '/krikri'

Development
-----------

Check out this repository and run:

    bundle install
    rake jetty:unzip
    rake jetty:config

Run the tests with:

    rake ci

Or you can start the dummy application with:

    rake engine_cart:generate
    bundle update
    rake jetty:start
    cd spec/internal
    rails s

To index a sample aggregation into solr, from `/krikri/spec/internal`:
    rake krikri:index_sample_aggregation

To index an _invalid_ sample aggregation into solr:
    rake krikri:index_invalid_aggregation

To delete the sample aggregation:
    rake krikri:delete_sample_aggregation

To update/restart dummy application, from the root KriKri directory:
    git pull
    bundle update
    rake engine_cart:clean
    rake engine_cart:generate
    cd spec/internal
    rails s

To update/restart jetty, from the root KriKri directory:
    git pull
    bundle update
    rake jetty:stop
    rake jetty:config
    rake jetty:start

To create a sample institution and harvest source, from `/krikri/spec/internal`:
    rake krikri:create_sample_institution

To delete the sample institution and harvest source:
    rake krikri:delete_sample_institution

Contribution Guidelines
-----------------------
Please observe the following guidelines:

  - Write tests for your contributions.
  - Document methods you add using YARD annotations.
  - Follow the included style guidelines (i.e. run `rubocop` before committing).
  - Use well formed commit messages.

Copyright & License
--------------------

Copyright Digital Public Library of America, 2014
