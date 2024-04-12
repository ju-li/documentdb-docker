-- add the distance function to index support for $geoNear
ALTER OPERATOR FAMILY __API_CATALOG_SCHEMA__.bson_gist_geometry_ops_2d USING gist ADD OPERATOR 25 __API_CATALOG_SCHEMA__.<|-|>(__CORE_SCHEMA__.bson, __CORE_SCHEMA__.bson) FOR ORDER BY pg_catalog.float_ops;
ALTER OPERATOR FAMILY __API_CATALOG_SCHEMA__.bson_gist_geography_ops_2d USING gist ADD OPERATOR 25 __API_CATALOG_SCHEMA__.<|-|>(__CORE_SCHEMA__.bson, __CORE_SCHEMA__.bson) FOR ORDER BY pg_catalog.float_ops;
 