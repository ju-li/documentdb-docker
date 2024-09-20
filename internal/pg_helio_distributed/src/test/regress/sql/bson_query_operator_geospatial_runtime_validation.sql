SET search_path TO helio_core,helio_api,helio_api_catalog,helio_api_internal;
SET citus.next_shard_id TO 1605000;
SET helio_api.next_collection_id TO 160500;
SET helio_api.next_collection_index_id TO 160500;

SELECT helio_api.drop_collection('db', 'geoquerytest') IS NOT NULL;
SELECT helio_api.create_collection('db', 'geoquerytest') IS NOT NULL;

-- avoid plans that use the primary key index
SELECT helio_distributed_test_helpers.drop_primary_key('db','geoquerytest');

-- Verify that geospatial query operators throw not supported
-- if helio_api.enableGeospatial is not turned ON
SET helio_api.enableGeospatial = OFF;
-- $geoWithin / $within
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": [[10, 10], [100, 100]]}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": [[10, 10], [100, 100]]}}}';

RESET helio_api.enableGeospatial;

-- Top level validations
SET helio_api.enableGeospatial = ON;

-- Insert so that validations kick in
SELECT helio_api.insert_one('db','geoquerytest','{ "z" : { "y": [10, 10] } }', NULL);

SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": 1 }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": { "$numberInt": "1" } }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": { "$numberLong": "1" } }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": { "$numberDouble": "1" } }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": { "$numberDecimal": "1" } }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": [10, 10] }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": true }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": false }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": { "$undefined": true } }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": "Geometry" }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"a": [10, 20]}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"box": [10, 20]}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"center": [10, 20]}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"polygon": [10, 20]}}}';

SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": 1 }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": { "$numberInt": "1" } }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": { "$numberLong": "1" } }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": { "$numberDouble": "1" } }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": { "$numberDecimal": "1" } }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": [10, 10] }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": true }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": false }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": { "$undefined": true } }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": "Geometry" }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"a": [10, 20]}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"box": [10, 20]}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"center": [10, 20]}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"polygon": [10, 20]}}}';

-- Valid Shape operator validations
-- $box
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": "Points" }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": { }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": 1 }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": true }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": {"w": 10, "x": 10, "y": 11, "z": 12}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": {"bottomLeftX": 10, "bottomLeftY": 10, "topRightX": 11, "topRightY": 12}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": {"bottomLeft": { "x": [10], "y": 10 }, "topRight": { "x": 11, "y": 11}}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": {"bottomLeft": { "x": 10, "y": "10" }, "topRight": { "x": 11, "y": 11}}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": {"bottomLeft": { "x": 10, "y": 10 }, "topRight": { "x": true, "y": 11}}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": {"bottomLeft": { "x": 10, "y": 10 }, "topRight": { "x": 11, "y": {"y": 10}}}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": [10, 11, 12, 13] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": [[[10], 10], [11, 11]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": [[10, "10"], [11, 11]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": [[10, 10], [true, 11]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": [[10, 10], [11, {"y": 11}]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": [[10, 10]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": [[10, { "$numberDouble": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": [[10, { "$numberDouble": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": [[10, { "$numberDecimal": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": [[10, { "$numberDecimal": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$box": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf

SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": "Points" }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": { }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": 1 }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": true }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": {"w": 10, "x": 10, "y": 11, "z": 12}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": {"bottomLeftX": 10, "bottomLeftY": 10, "topRightX": 11, "topRightY": 12}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": {"bottomLeft": { "x": [10], "y": 10 }, "topRight": { "x": 11, "y": 11}}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": {"bottomLeft": { "x": 10, "y": "10" }, "topRight": { "x": 11, "y": 11}}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": {"bottomLeft": { "x": 10, "y": 10 }, "topRight": { "x": true, "y": 11}}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": {"bottomLeft": { "x": 10, "y": 10 }, "topRight": { "x": 11, "y": {"y": 10}}}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": [10, 11, 12, 13] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": [[[10], 10], [11, 11]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": [[10, "10"], [11, 11]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": [[10, 10], [true, 11]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": [[10, 10], [11, {"y": 11}]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": [[10, 10]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": [[10, { "$numberDouble": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": [[10, { "$numberDouble": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": [[10, { "$numberDecimal": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": [[10, { "$numberDecimal": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$box": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf

-- $center
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": "Points" }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": 1 }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": true }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": { "center": { "x": [10], "y": 10 }, "radius": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": { "center": { "x": 10, "y": "10" }, "radius": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": { "center": { "x": { "xx": 10 }, "y": "10" }, "radius": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": { "center": { "x": 10, "y": 10 }, "radius": "10" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": { "center": { "x": 10, "y": 10 }, "radius": -10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": { "center": { "x": 10, "y": 10 }, "radius": true } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [ [ [10], 10], 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [ [10, "10"], 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [ [ {"x": 10 } , 10], 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [ [10, 10], "10" ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [ [10, 10], -10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [ [10, 10], true ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": { "center": { "x": 10, "y": 10 }, "radius": 10, "extra": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [ [10, 10], 10, 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": { "center": { "x": 10, "y": 10 }}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [ [10, 10] ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [[10, { "$numberDouble": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [[10, { "$numberDouble": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [[10, { "$numberDecimal": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [[10, { "$numberDecimal": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": {} }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$center": [] }}}';

SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": "Points" }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": 1 }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": true }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": { "center": { "x": [10], "y": 10 }, "radius": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": { "center": { "x": 10, "y": "10" }, "radius": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": { "center": { "x": { "xx": 10 }, "y": "10" }, "radius": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": { "center": { "x": 10, "y": 10 }, "radius": "10" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": { "center": { "x": 10, "y": 10 }, "radius": -10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": { "center": { "x": 10, "y": 10 }, "radius": true } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": [ [ [10], 10], 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": [ [10, "10"], 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": [ [ {"x": 10 } , 10], 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": [ [10, 10], "10" ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": [ [10, 10], -10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": [ [10, 10], true ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": { "center": { "x": 10, "y": 10 }, "radius": 10, "extra": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": [ [10, 10], 10, 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": { "center": { "x": 10, "y": 10 }}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": [ [10, 10] ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": [[10, { "$numberDouble": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": [[10, { "$numberDouble": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": [[10, { "$numberDecimal": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": [[10, { "$numberDecimal": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$center": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"geo.loc": {"$within": {"$center": [[10, 10], { "$numberDecimal": "NaN" }] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"geo.loc": {"$within": {"$center": [[10, 10], { "$numberDecimal": "-NaN" }] }}}'; 
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"geo.loc": {"$within": {"$center": [[10, 10], { "$numberDecimal": "-Infinity" }] }}}'; 

-- $centerSphere
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": "Points" }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": 1 }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": true }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": { "centerSphere": { "x": [10], "y": 10 }, "radius": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": { "centerSphere": { "x": 10, "y": "10" }, "radius": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": { "centerSphere": { "x": { "xx": 10 }, "y": "10" }, "radius": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": { "centerSphere": { "x": 10, "y": 10 }, "radius": "10" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": { "centerSphere": { "x": 10, "y": 10 }, "radius": -10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": { "centerSphere": { "x": 10, "y": 10 }, "radius": true } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [ [ [10], 10], 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [ [10, "10"], 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [ [ {"x": 10 } , 10], 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [ [10, 10], "10" ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [ [10, 10], -10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [ [10, 10], true ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": { "centerSphere": { "x": 10, "y": 10 }, "radius": 10, "extra": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [ [10, 10], 10, 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": { "centerSphere": { "x": 10, "y": 10 }}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [ [10, 10] ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [[10, { "$numberDouble": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [[10, { "$numberDouble": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [[10, { "$numberDecimal": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [[10, { "$numberDecimal": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": [] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$centerSphere": {} }}}';

SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": "Points" }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": 1 }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": true }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": { "centerSphere": { "x": [10], "y": 10 }, "radius": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": { "centerSphere": { "x": 10, "y": "10" }, "radius": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": { "centerSphere": { "x": { "xx": 10 }, "y": "10" }, "radius": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": { "centerSphere": { "x": 10, "y": 10 }, "radius": "10" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": { "centerSphere": { "x": 10, "y": 10 }, "radius": -10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": { "centerSphere": { "x": 10, "y": 10 }, "radius": true } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": [ [ [10], 10], 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": [ [10, "10"], 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": [ [ {"x": 10 } , 10], 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": [ [10, 10], "10" ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": [ [10, 10], -10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": [ [10, 10], true ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": { "centerSphere": { "x": 10, "y": 10 }, "radius": 10, "extra": 10 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": [ [10, 10], 10, 10 ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": { "centerSphere": { "x": 10, "y": 10 }}}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": [ [10, 10] ] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": [[10, { "$numberDouble": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": [[10, { "$numberDouble": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": [[10, { "$numberDecimal": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": [[10, { "$numberDecimal": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$centerSphere": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"geo.loc": {"$within": {"$centerSphere": [[10, 10], { "$numberDecimal": "NaN" }] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"geo.loc": {"$within": {"$centerSphere": [[10, 10], { "$numberDecimal": "-NaN" }] }}}'; 
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"geo.loc": {"$within": {"$centerSphere": [[10, 10], { "$numberDecimal": "-Infinity" }] }}}'; 

-- $polygon
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": "Points" }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": 1 }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": true }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": { "first": {"x": 10, "y": 10}, "second": {"x": 10, "y": 10} } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": { "first": {"x": [10], "y": 10}, "second": {"x": 10, "y": 10}, "third": {"x": 10, "y": 10} } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": { "first": {"x": 10, "y": "10"}, "second": {"x": 10, "y": 10}, "third": {"x": 10, "y": 10} } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": { "first": {"x": 10, "y": 10}, "second": {"x": { "xx" : 10 }, "y": 10}, "third": {"x": 10, "y": 10} } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": { "first": {"x": 10, "y": 10}, "second": {"x": 10, "y": 10}, "third": {"x": true, "y": 10} } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": { "first": {"x": 10, "y": 10}, "second": {"x": 10, "y": 10}, "third": {"x": 10, "y": false} } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": [[10, 10], [11, 11]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": [[[10], 10], [11, 11], [12, 12]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": [[10, {"y": 10}], [11, 11], [12, 12]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": [[10, 10], ["11", 11], [12, 12]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": [[10, 10], [11, 11], [true, 12]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": [[10, 10], [11, 11], [12, false]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": [[10, { "$numberDouble": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": [[10, { "$numberDouble": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": [[10, { "$numberDecimal": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": [[10, { "$numberDecimal": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$polygon": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf

SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": "Points" }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": 1 }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": true }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": { "first": {"x": 10, "y": 10}, "second": {"x": 10, "y": 10} } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": { "first": {"x": [10], "y": 10}, "second": {"x": 10, "y": 10}, "third": {"x": 10, "y": 10} } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": { "first": {"x": 10, "y": "10"}, "second": {"x": 10, "y": 10}, "third": {"x": 10, "y": 10} } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": { "first": {"x": 10, "y": 10}, "second": {"x": { "xx" : 10 }, "y": 10}, "third": {"x": 10, "y": 10} } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": { "first": {"x": 10, "y": 10}, "second": {"x": 10, "y": 10}, "third": {"x": true, "y": 10} } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": { "first": {"x": 10, "y": 10}, "second": {"x": 10, "y": 10}, "third": {"x": 10, "y": false} } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": [[10, 10], [11, 11]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": [[[10], 10], [11, 11], [12, 12]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": [[10, {"y": 10}], [11, 11], [12, 12]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": [[10, 10], ["11", 11], [12, 12]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": [[10, 10], [11, 11], [true, 12]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": [[10, 10], [11, 11], [12, false]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": [[10, { "$numberDouble": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": [[10, { "$numberDouble": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": [[10, { "$numberDecimal": "inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": [[10, { "$numberDecimal": "-inf" }]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$within": {"$polygon": [[10, { "$numberDecimal": "1e309" }]] }}}'; -- This is overflow and hence inf

-- $geoIntersects operator validations
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": 1 }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { } }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": [{ "$geometry": {} }] }}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": {"$box": [[10, 20], [30, 40]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": {"$polygon": [[10, 20], [30, 40]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": {"$centerSphere": [[10, 20], [30, 40]] }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": 1 }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": {} }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "point" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "linestring" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "polygon" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "multipoint" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "multilinestring" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "multipolygon" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "geometrycollection" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "invalidGeoJsonType" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "LineString" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "MultiPoint" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "MultiLineString" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "MultiPolygon" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "GeometryCollection" } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "Coordinates": [10, 10] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "coordinates": {"x": 10, "y": "Text"} } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "coordinates": [[1, 2], [3, 4]] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "coordinates": [1, "text"] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "coordinates": [{"x": 10, "y": 10}] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "LineString", "coordinates": [1, 2] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "LineString", "coordinates": [[1, 2]] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "LineString", "coordinates": [[1, 2], [3, "text"]] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "LineString", "coordinates": [[1, 2], {"x": 10, "y": 10}] } }}}';

-- Polygon extra validations
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [1, 2] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[1, 2], [3, 4]] }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[]] }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[1, 2], [3, 4]]] }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[1, 2], [3, 4], [5, 6], [1, 3]]] }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[1, 2], [3, 4], [5, 6], [2, 1]]] }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[1, 2], [3, 4], [1, 2]]] }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[1, 1], [1, 5], [3, 4], [0, 3], [1, 1]]] }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[0, 0], [0, 1], [1, 1], [-2, -1], [0, 0]]] }}}}'; -- Edges of polygon intersect, 2d area is 0
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[1, 0], [0, 10], [10, 10], [0, 0], [1, 0]]]}}}}'; -- Edges of polygon intersect, 2d area is not 0
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[0, 0], [0, 80], [80, 80], [80, 0], [0, 0]],[[0, 10], [0, 70], [75, 75], [75, 25], [0, 10]]]}}}}'; -- Polygon with hole edge part of (overlapping) outer ring
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[0, 0], [0, 80], [80, 80], [80, 0], [0, 0]],[[0, 0], [0, 80], [75, 75], [75, 25], [0, 0]]]}}}}'; -- Polygon with hole having 1 edge common with outer ring
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[0, 2], [2, 0], [2, 2], [0, 0], [1, 2], [3, 2], [4, 2], [0, 2]]]}}}}'; -- Combination polygon - both intersection and overlap
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[1, 1], [1, 5], [5, 5], [5, 1], [1, 1]], []] }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[1, 1], [1, 5], [5, 5], [5, 1], [1, 1]], [[0, 0], [0, 6], [6, 6], [6, 0], [0, 0]]] }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[0, 0], [0, 1], [1, 1], [1, 0], [0, 0]], [[0, 0], [0, 1], [1, 1], [1, 0], [0, 0]]] }}}}'; --Holes covering the polygon
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [ [[0, 0], [0, 1], [1, 1], [1, 0], [0, 0]], [[0, 0], [0, 0.5], [1, 0.5], [1, 0], [0, 0]], [[0, 0.5], [0, 1], [1, 1], [1, 0.5], [0, 0.5]] ] }}}}'; -- Multi holes covering the polygon
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[1, 2], [2, 3], [1, 2], [3, 4], [1, 2]]] }}}}'; -- Duplicate non adjacent vertices

SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "MultiPoint", "coordinates": [1, 2] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "MultiPoint", "coordinates": {} } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "MultiPoint", "coordinates": [[1, 2], [3, "text"]] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "MultiPoint", "coordinates": [[[1, 2], [3, 4]]] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "MultiPolygon", "coordinates": [ [[[1, 2], [3,4]]], [] ] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "MultiPolygon", "coordinates": [ [], [] ] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "MultiPolygon", "coordinates": [ [[[1, 2], [3, 4], [1, 2]]], [] ] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "MultiPolygon", "coordinates": [ [[[1, 1], [1, 5], [5, 5], [5, 1], [1, 1]], []], []] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "MultiPolygon", "coordinates": [ [[[1, 1], [1, 5], [5, 5], [5, 1], [1, 1]]], [[[1, 1], [1, 5], [5, 5], [5, 1], [1, 1]], [[0, 0], [0, 6], [6, 6], [6, 0], [0, 0]]]] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "MultiLineString", "coordinates": [[[1, 1], [1, 5], [3, 4], [0, 3], [1, 1]], [[1, 2]]] }}}}';

-- Geometry Collections
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "GeometryCollection", "geometries": {} }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "GeometryCollection", "geometries": [] }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "GeometryCollection", "geometries": [{ "type": "Point", "coords": [10, 10] }] }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "GeometryCollection", "geometries": [{ "type": "unknownPoint", "coords": [10, 10] }] }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "GeometryCollection", "geometries": [{ "type": "Point", "coordinates": [10, "text"] }] }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "GeometryCollection", "geometries": [{ "type": "Point", "coordinates": [10, 10] }, {"type": "LineString", "coordinates": [[1, 2], [2, 3]]}, {"type": "Polygon", "coordinates": [[[1, 1], [5, 5], [2, 6], [1, 1]]]}, {"type": "LineString", "coordinates": [[10, 10]]}] }}}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "GeometryCollection", "geometries": [{ "type": "GeometryCollection", "geometries": [{"type": "Point", "coordinates": [10, 10]}]}] }}}}';

--CRS checks
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "crs": [], "coordinates": [1, 2] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "crs": {}, "coordinates": [1, 2] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "crs": {"type": 1, "name": 1}, "coordinates": [1, 2] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "crs": {"type": "name"}, "coordinates": [1, 2] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "crs": {"type": "name", "properties": {}}, "coordinates": [1, 2] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "crs": {"type": "name", "properties": { "name": 2 }}, "coordinates": [1, 2] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "crs": {"type": "name", "properties": {"name": "UnknownCRS"}}, "coordinates": [1, 2] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "crs": {"type": "name", "properties": {"name": "urn:x-mongodb:crs:STRICTWINDING:EPSG:4326" } }, "coordinates": [1, 2] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "crs": {"properties": {}, "type": "name"}, "coordinates": [1, 2] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Point", "crs": { "type": "name", "properties": { "name": "urn:x-mongodb:crs:strictwinding:EPSG:4326" } }, "coordinates": [1, 2] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoIntersects": { "$geometry": { "type": "Polygon", "coordinates": [[[1, 1], [5, 5], [2, 6], [1, 1]]], "crs": { "type": "name", "properties": { "name": "urn:x-mongodb:crs:strictwinding:EPSG:4326" } }} }}}';

-- $geoWithin with non polygon GeoJSON don't work
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": { "$geometry": { "type": "Point", "coordinates": [10, 10] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": { "$geometry": { "type": "MultiPoint", "coordinates": [[10, 10], [20, 20]] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": { "$geometry": { "type": "LineString", "coordinates": [[7.1, 7.2], [4.1, 4.2], [7.3, 7.4], [2.1, 2.2]] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": { "$geometry": { "type": "MultiLineString", "coordinates": [[[7.1, 7.2], [4.1, 4.2], [7.3, 7.4], [2.1, 2.2]]] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": { "$geometry": { "type": "GeometryCollection", "geometries": [ {"type": "LineString", "coordinates": [[-25, -25], [25, 25]]}, {"type": "Point", "coordinates": [2.1, 2.2]} ] } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$geometry": { "lon": 50, "lat": 50 } }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$geometry": [51, 51] }}}';


-- Out of bounds checks for GeoJSON
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$geometry": {"type": "Point", "coordinates": [200, 200]} }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$geometry": {"type": "LineString", "coordinates": [[-200, -200], [50, 50]]} }}}';
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a": {"$geoWithin": {"$geometry": {"type": "Polygon", "coordinates": [[[-200, -200], [50, 50], [30, 30], [-200, -200]]] } }}}';

-- Also check some cases which are specific to runtime
-- e.g. GeoJson point type is matched only during runtime if there is no 2d index on the field
-- If the index is created then it would simply error out as this is not a proper point format for the index
SELECT helio_api.insert_one('db','geoquerytest','{ "_id" : 100, "a" : { "b": { "type": "Point", "coordinates": [60, 60] } } }', NULL);
SELECT helio_api.insert_one('db','geoquerytest','{ "_id" : 101, "a" : [{ "b": { "type": "Point", "coordinates": [65, 65] } }, { "b": { "type": "Point", "coordinates": [70, 70] } }, { "b": { "type": "Point", "coordinates": [75, 75] } }] }', NULL);
-- This is Geojson Polygon which should not match for 2d planar calculations using $box, $polygon, $center in $geowithin
SELECT helio_api.insert_one('db','geoquerytest','{ "_id" : 102, "a" : { "b": {"type": "Polygon", "coordinates": [[ [10, 10], [10, 10], [10, 10], [10, 10] ]] } } }', NULL);

SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a.b": {"$geoWithin": {"$box": [[10, 10], [100, 100]]}}}' ORDER BY object_id;
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a.b": {"$geoWithin": {"$center": [[10, 10], 100]}}}' ORDER BY object_id;
SELECT document FROM helio_api.collection('db', 'geoquerytest') WHERE document @@ '{"a.b": {"$geoWithin": {"$polygon": [[10, 10], [10, 100], [100, 100], [100, 10]]}}}' ORDER BY object_id;


-- insert some invalid polygons - don't error out on runtime as polygon validation during inserting happens only in index case
SELECT helio_api.insert_one('db','geoquerytest','{"_id": 501, "geo" : { "loc" : {"type": "Polygon", "coordinates": [[[0, 0], [0, 1], [1, 1], [-2, -1], [0, 0]]] } } }', NULL); -- self intersecting polygon with 0 geometrical area
SELECT helio_api.insert_one('db','geoquerytest','{"_id": 502, "geo" : { "loc" : {"type": "Polygon", "coordinates": [[[1, 0], [0, 10], [10, 10], [0, 0], [1, 0]]] } } }', NULL); -- self intersecting polygon with non-zero geometrical area
SELECT helio_api.insert_one('db','geoquerytest','{"_id": 503, "geo" : { "loc" : {"type": "Polygon", "coordinates": [[[0, 0], [0, 80], [80, 80], [80, 0], [0, 0]],[[0, 10], [0, 70], [75, 75], [75, 25], [0, 10]]] } } }', NULL); -- hole edge lies on outer ring edge
SELECT helio_api.insert_one('db','geoquerytest','{"_id": 504, "geo" : { "loc" : {"type": "Polygon", "coordinates": [[[0, 0], [0, 80], [80, 80], [80, 0], [0, 0]],[[0, 0], [0, 80], [75, 75], [75, 25], [0, 0]]] } } }', NULL); -- hole shares an edge with outer ring
SELECT helio_api.insert_one('db','geoquerytest','{"_id": 505, "geo" : { "loc" : {"type": "Polygon", "coordinates": [[[0, 0], [0, 80], [80, 80], [80, 0], [0, 0]],[[10, 10], [10, 70], [75, 75], [75, 25], [10, 10]],[[10,20], [10,30], [50, 50], [10, 20]]] } } }', NULL); -- 3rd ring edge lies on 2nd ring edge
