# OpenESPI Database Graphs

This folder contains auto-generated graphs for the dev MySQL database.

## 1) Schema topology (FK graph)

```mermaid
flowchart LR
  %% Schema FK Graph: datacustodian
  t_application_information[application_information]
  t_electric_power_quality_summaries[electric_power_quality_summaries]
  t_electric_power_usage_summaries[electric_power_usage_summaries]
  t_interval_blocks[interval_blocks]
  t_interval_readings[interval_readings]
  t_line_item[line_item]
  t_meter_reading_related_links[meter_reading_related_links]
  t_meter_readings[meter_readings]
  t_reading_types[reading_types]
  t_reading_types_meter_readings[reading_types_meter_readings]
  t_retail_customers[retail_customers]
  t_service_delivery_points[service_delivery_points]
  t_subscriptions[subscriptions]
  t_subscriptions_usage_points[subscriptions_usage_points]
  t_time_configurations[time_configurations]
  t_usage_point_related_links[usage_point_related_links]
  t_usage_points[usage_points]
  t_usage_summaries[usage_summaries]
  t_electric_power_quality_summaries -- "usage_point_id→id" --> t_usage_points
  t_electric_power_usage_summaries -- "usage_point_id→id" --> t_usage_points
  t_interval_blocks -- "meter_reading_id→id" --> t_meter_readings
  t_interval_readings -- "interval_block_id→id" --> t_interval_blocks
  t_line_item -- "electric_power_usage_summary_id→id" --> t_electric_power_usage_summaries
  t_line_item -- "usage_summary_id→id" --> t_usage_summaries
  t_meter_reading_related_links -- "meter_reading_id→id" --> t_meter_readings
  t_meter_readings -- "reading_type_id→id" --> t_reading_types
  t_meter_readings -- "usage_point_id→id" --> t_usage_points
  t_reading_types_meter_readings -- "meterReadings_id→id" --> t_meter_readings
  t_reading_types_meter_readings -- "reading_types_id→id" --> t_reading_types
  t_subscriptions -- "applicationInformation_id→id" --> t_application_information
  t_subscriptions -- "retail_customer_id→id" --> t_retail_customers
  t_subscriptions_usage_points -- "subscriptions_id→id" --> t_subscriptions
  t_usage_point_related_links -- "usage_point_id→id" --> t_usage_points
  t_usage_points -- "localTimeParameters_id→id" --> t_time_configurations
  t_usage_points -- "retail_customer_id→id" --> t_retail_customers
  t_usage_points -- "serviceDeliveryPoint_id→id" --> t_service_delivery_points
  t_usage_points -- "subscription_id→id" --> t_subscriptions
  t_usage_summaries -- "usage_point_id→id" --> t_usage_points
```

## 2) Privacy variant linkages (live data)

```mermaid
flowchart LR
  %% Privacy Variant Graph (data): datacustodian
  subgraph 5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB[5446AF3F-7D2B-4B40-8F3B-9DFA49C22EEB]
    u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB[[canonical
5446AF3F-7D2B-4B40-8F3B-9DFA49C22EEB]]
    u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB_full[privacy:full
5446AF3F-7D2B-4B40-8F3B-9DFA49C22EEB-full]
    u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB -- "privacy:full" --> u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB_full
    u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB_full -. "canonical" .-> u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB
    u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB_high[privacy:high
5446AF3F-7D2B-4B40-8F3B-9DFA49C22EEB-high]
    u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB -- "privacy:high" --> u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB_high
    u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB_high -. "canonical" .-> u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB
    u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB_low[privacy:low
5446AF3F-7D2B-4B40-8F3B-9DFA49C22EEB-low]
    u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB -- "privacy:low" --> u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB_low
    u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB_low -. "canonical" .-> u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB
    u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB_medium[privacy:medium
5446AF3F-7D2B-4B40-8F3B-9DFA49C22EEB-medium]
    u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB -- "privacy:medium" --> u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB_medium
    u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB_medium -. "canonical" .-> u_5446AF3F_7D2B_4B40_8F3B_9DFA49C22EEB
  end
```

## 3) Data sharing flow (context, start → finish)

Open and view in the HTML viewer (recommended):

- `view.html` (served locally)

Or read the Mermaid source:

- `flow_consent_to_data.mmd`

## 4) Privacy selection → exported data

- `flow_privacy_variant_selection.mmd`

## Regenerating

These files are generated from your live MySQL state:

- `dc_schema_focus.dot` / `dc_schema_focus.mmd`
- `dc_privacy.dot` / `dc_privacy.mmd`

Run:

- `MYSQL_USER=root MYSQL_PASS=password OpenESPI-Common-java/bin/db_graph.py schema --filter 'usage_points|usage_point_related_links|subscriptions|retail_customers|meter_readings|interval_blocks|reading_types|usage_summaries' --out-dot OpenESPI-Common-java/docs/graphs/dc_schema_focus.dot --out-mmd OpenESPI-Common-java/docs/graphs/dc_schema_focus.mmd`
- `MYSQL_USER=root MYSQL_PASS=password OpenESPI-Common-java/bin/db_graph.py privacy --out-dot OpenESPI-Common-java/docs/graphs/dc_privacy.dot --out-mmd OpenESPI-Common-java/docs/graphs/dc_privacy.mmd`

If you want polished SVG/PNG exports, install Graphviz (`dot`) and render the `.dot` files.
