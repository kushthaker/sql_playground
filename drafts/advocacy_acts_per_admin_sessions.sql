-- ADOVOCACY ACTS PER HUB/ ADMIN SESSIONS PER HUB, MONTHLY
-- method 1: totals events per hub/ total admin session per hub, monthly
select
  total_events.created_date as month,
  (events_count::float / admin_sessions_count::float) as events_per_admin_session
from
(
  select 
    to_char(created_at, 'YYYY-MM') as created_date, 
    count(distinct id) as events_count
  from events
  where to_char(created_at, 'YYYY-MM') != to_char(getdate(), 'YYYY-MM')
  group by 1
) as total_events
join 
(
select 
	to_char(s.created_at, 'YYYY-MM') as created_date, 
	count(distinct s.id) as admin_sessions_count
from session_logs s
inner join contacts c on s.contact_id = c.id
where c.type = 'Corporate' and c.email not like '%influitive%'
group by 1
) as total_admin_sessions on total_events.created_date = total_admin_sessions.created_date
order by 1 asc

-- ADOVOCACY ACTS PER HUB/ ADMIN SESSIONS PER HUB, MONTHLY
-- method 2: median events per hub/ median admin session per hub, monthly
select
  event_count.month as month,
  median_event_count,
  median_admin_sessions_per_hub,
  (median_event_count::float) / (median_admin_sessions_per_hub::float) as events_per_admin_session
from 
(
  -- MEDIAN EVENT_COUNT MONTHLY
  select
    distinct created_date as month,
    median(events_count) over (partition by created_date) as median_event_count
  from 
  (
    select 
      to_char(e.created_at, 'YYYY-MM') as created_date, 
      subdomain, 
      count(e.id) as events_count
    from events e
    inner join companies co on e.company_id = co.id
    where subdomain in ('mobify', 'adeptia', 'seismic', 'envoy', 'modeln', 'samanage', 'hireright', '15five', 'siriusdecisions', 'maxsold', 'ecobee', 'touchbistro', 'onelogin', 'qlik', 'skyhighnetworks', 'evault', 'ultimatesoftware', 'echosign', 'esiinternational', 'leonardo', 'creationagency', 'shoretel', 'snacknation', 'cco', 'amtdirect', 'computersupport', 'salesforcepremier', 'smartenterprise', 'liaison', 'predictablerevenue', 'saucelabs', 'zama', 'recruitloop', 'druva', 'ektron', 'liveintent', 'joinme', 'on-site', 'plangrid', 'eventboard', 'pointdrive', 'fisherbioservices', 'ibmhybridcloud', 'mindjet', 'keepersecurity', 'vsl3', 'totango', 'forrester', 'aerohive', 'staples', 'xactly', 'connectandsell', 'iovation', 'kontagent', 'turnto', 'arrowecs', 'inkling', 'firstcal', 'membersolutions', 'coupa', 'opsbridgeinsiders', 'boomtown', 'epn', 'demandspring', 'conga', 'invoca', 'intalio', 'marketbridge', 'owncloud', 'loopup', 'revegy', 'glasscubes', 'nginx', 'lotame', 'whitlock', 'homestars', 'pgisales', 'clearslide', 'acquia', 'brainshark', 'zeroturnaround', 'eloqua', 'ocz', 'herok12', 'pulsesecure', 'arrowsi', 'ironmountain', 'forcepoint', 'springcm', 'astutesolutions', 'twitter', 'recombo', 'signatureworldwide', 'kissmetrics', 'shareologybook', 'clearcare', 'worketc', 'doubledutch', 'pardot', 'tribehr', 'vpprn', 'nwnit', 'blackline', 'billdotcom', 'smartthings', 'zenpayroll', 'firmex', 'pearson', 'verint', 'tagetik', 'datawatch', 'box', 'purestorage', 'anaplan', 'avalara', 'esker', 'apriori', 'ibmchampion', 'communityforce', 'learncore', 'schooladmin', 'ringcentral', 'watsonhealth', 'apminsiders', 'nitro', 'relayventures', 'clari', 'tangocard', 'code42software', 'fnts', 'kiratalent', 'hootsuite', 'neopost', 'socrata', 'hpadm', 'kace', 'zapproved', 'reviewsnap', 'riseinteractive', 'adaptiveinsights', 'zend', 'genologics', 'sas', 'acst', 'logmein', 'epicorsoftware', 'clearfit', 'netfactor', 'ibm', 'cija', 'billtrust', 'buffini', 'attask', 'cloudwords', 'cloudon', 'termsync', 'jwplayer', 'cvent', 'vht', 'acmcommunity', 'kubotek', 'desk', 'readytalk', 'semrush', 'adar', 'apigee', 'metaswitch', 'nexmo', 'tripleseat', 'swarm', 'veracode', 'paychex', 'mogiv', 'unitrends', 'xcmsolutions', 'intuitquickbase', 'adp', 'rapid7', 'adsensa', 'mitel', 'conductor', 'docusign', 'easycleanenergy', 'quorum', 'wegohealth', 'evolveip', 'blackberry', 'riverbed', 'bluemix', 'freshbooks', 'eastwick', 'limelight', 'macadamian', 'selectica', 'aryaka', 'ourcrowd', 'gochrysalis', 'datanauts', 'dyn', 'ceridian', 'sdl', 'nanawall', 'hortonworks', 'infoblox', 'skulpt', 'spiceworks', 'leadpages', 'cheebachews', 'namely', 'optimizely', 'tophat', 'hatchbuck', 'allocadia', 'acl', 'engineyard', 'transfast', 'smartbear', '1stlightenergy', 'socialimprints', 'appneta', 'bronto', 'dashlane', 'dynatrace', 'halogen', 'actuate', 'wrike', 'prnewswire', 'virginpulse', 'crazydomains', 'emc', 'databank', 'clinicient', 'leveleleven', 'findbetter', 'cielo', 'toast', 'innroad', 'savo', 'fuseuniversal', 'scholarswag', 'mongodb', 'insightsquared', 'klipfolio', 'northpoint', 'imginsiders', 'edmodo', 'gofmx', 'thepredictiveindex', 'parchment', 'rocketfuel', 'bankerstoolbox', 'demandgen', 'nutanix', 'clarizen', 'itominsiders', 'salesforce1platform', 'acronis', 'predixion', 'crimsonhexagon', 'nxtbookmedia', 'jda', 'demandbase', 'acquisio', 'atlassian', 'futuresuper', 'apprenda', 'neustar', 'fliptop', 'vip', 'verafin', 'homeaway', 'tcsociety', 'insightpool', 'linkedin', 'cielotalent', 'netscout', 'cox', 'cloudelements', 'frost', 'glowpoint', 'dexterchaney', 'nlyte', 'hirevue', 'bah', 'insidesales', 'covidien', 'gnapartners', 'gooddata', 'calabrio', 'on24', 'symantecgold', 'intronis', 'qualtrics', 'getcake', 'smartling', 'couch-associates', 'salesloft', 'trelora', 'bistromd', 'siia', 'safedose', 'bluecat', 'acton', 'gainsight', 'couchdb', 'vif', 'apttus', 'impactgroup', 'rolepoint', 'businessolver', 'rivs', 'egencia', 'ilabsmoney', 'skotidasconsulting', 'kareo', 'procurify', 'peoplematter', 'datadotcom', 'insperity', 'bbchampions', 'hubspot', 'windward', 'opendns', 'knowledgevision', 'credibly', 'gohubble', 'silanis', 'quantum', 'res', 'hostanalytics', 'distilnetworks', 'uberflip', 'ezidebit', 'salesforcedevs', 'firstround', 'okta', 'alfresco', 'trinet', 'insurity', 'reltio', 'sococo', 'pitneybowes', 'marketo', 'replicon', 'marketingcloud', 'heinzmarketing', 'monetate', 'trackmaven', 'myjeweller', 'g5', 'hpsweducation', 'openview', 'compliancescience', 'diligent', 'elitesem', 'asigra', 'fleetsharp', 'enterasys', 'bomgar', 'mhiglobal', 'sleetergroup', 'devmvp', 'paysimple', 'ppminsiders', 'kapost', 'mulesoft', 'dundas', 'victorops', 'bmc', 'montage', 'vidyard', 'theclub', 'deltek', 'grasshopper', 'talari', 'mavenlink', 'netbase', 'customerreferenceforum', 'onecallnow', 'litmos', 'cloudbees', 'asusitaly', 'contactatonce', 'blackduck', 'junctionsolutions', 'insideview', 'reflexis', 'carouselindustries', 'myemma', 'greenbiz', 'tintri', 'hiremojo', 'aconex', 'zerto', 'oraclesocial', 'talentwise', 'armanino', 'centrify', 'pinnacleprivatewealth', 'wiley', 'fonality', 'pedowitzgroup', 'applause', 'infusionsoft', 'myhealthop', 'prounlimited', 'genesys', 'raml', 'uptimesoftware', 'qvidian', 'saiglobal', 'looker', 'pingidentity', 'zscaler', 'netprospex', 'discoverorg', 'jumio', 'opensesame', 'messagesystems', 'hoopla', 'smarttech', 'liveramp', 'commonangels', 'bluewolf', 'strongview', 'bullhorn', 'deliciousliving', 'five9', 'eteacher', 'articulate-insiders', 'aciworldwide', 'zenpayroll-partner', 'mercurylabs', 'simplivity', 'brightpearl', 'inin', 'imanami', 'connectfirst', 'devolutions', 'icompass', 'stansberry', 'smashfly', 'moneytips', 'pgi')
    group by 1,2
  )
) as event_count 
join
(
  -- MEDIAN ADMIN SESSIONS PER HUB MONTHLY
  with session_count as
  (
    select 
      to_char(s.created_at, 'YYYY-MM') as created_date, 
      subdomain, 
      count(s.id) as sessions_count
    from session_logs s
    inner join companies co on s.company_id = co.id
    inner join contacts c on s.contact_id = c.id
    where c.type = 'Corporate' and email not like '%influitive%'
    and subdomain in ('mobify', 'adeptia', 'seismic', 'envoy', 'modeln', 'samanage', 'hireright', '15five', 'siriusdecisions', 'maxsold', 'ecobee', 'touchbistro', 'onelogin', 'qlik', 'skyhighnetworks', 'evault', 'ultimatesoftware', 'echosign', 'esiinternational', 'leonardo', 'creationagency', 'shoretel', 'snacknation', 'cco', 'amtdirect', 'computersupport', 'salesforcepremier', 'smartenterprise', 'liaison', 'predictablerevenue', 'saucelabs', 'zama', 'recruitloop', 'druva', 'ektron', 'liveintent', 'joinme', 'on-site', 'plangrid', 'eventboard', 'pointdrive', 'fisherbioservices', 'ibmhybridcloud', 'mindjet', 'keepersecurity', 'vsl3', 'totango', 'forrester', 'aerohive', 'staples', 'xactly', 'connectandsell', 'iovation', 'kontagent', 'turnto', 'arrowecs', 'inkling', 'firstcal', 'membersolutions', 'coupa', 'opsbridgeinsiders', 'boomtown', 'epn', 'demandspring', 'conga', 'invoca', 'intalio', 'marketbridge', 'owncloud', 'loopup', 'revegy', 'glasscubes', 'nginx', 'lotame', 'whitlock', 'homestars', 'pgisales', 'clearslide', 'acquia', 'brainshark', 'zeroturnaround', 'eloqua', 'ocz', 'herok12', 'pulsesecure', 'arrowsi', 'ironmountain', 'forcepoint', 'springcm', 'astutesolutions', 'twitter', 'recombo', 'signatureworldwide', 'kissmetrics', 'shareologybook', 'clearcare', 'worketc', 'doubledutch', 'pardot', 'tribehr', 'vpprn', 'nwnit', 'blackline', 'billdotcom', 'smartthings', 'zenpayroll', 'firmex', 'pearson', 'verint', 'tagetik', 'datawatch', 'box', 'purestorage', 'anaplan', 'avalara', 'esker', 'apriori', 'ibmchampion', 'communityforce', 'learncore', 'schooladmin', 'ringcentral', 'watsonhealth', 'apminsiders', 'nitro', 'relayventures', 'clari', 'tangocard', 'code42software', 'fnts', 'kiratalent', 'hootsuite', 'neopost', 'socrata', 'hpadm', 'kace', 'zapproved', 'reviewsnap', 'riseinteractive', 'adaptiveinsights', 'zend', 'genologics', 'sas', 'acst', 'logmein', 'epicorsoftware', 'clearfit', 'netfactor', 'ibm', 'cija', 'billtrust', 'buffini', 'attask', 'cloudwords', 'cloudon', 'termsync', 'jwplayer', 'cvent', 'vht', 'acmcommunity', 'kubotek', 'desk', 'readytalk', 'semrush', 'adar', 'apigee', 'metaswitch', 'nexmo', 'tripleseat', 'swarm', 'veracode', 'paychex', 'mogiv', 'unitrends', 'xcmsolutions', 'intuitquickbase', 'adp', 'rapid7', 'adsensa', 'mitel', 'conductor', 'docusign', 'easycleanenergy', 'quorum', 'wegohealth', 'evolveip', 'blackberry', 'riverbed', 'bluemix', 'freshbooks', 'eastwick', 'limelight', 'macadamian', 'selectica', 'aryaka', 'ourcrowd', 'gochrysalis', 'datanauts', 'dyn', 'ceridian', 'sdl', 'nanawall', 'hortonworks', 'infoblox', 'skulpt', 'spiceworks', 'leadpages', 'cheebachews', 'namely', 'optimizely', 'tophat', 'hatchbuck', 'allocadia', 'acl', 'engineyard', 'transfast', 'smartbear', '1stlightenergy', 'socialimprints', 'appneta', 'bronto', 'dashlane', 'dynatrace', 'halogen', 'actuate', 'wrike', 'prnewswire', 'virginpulse', 'crazydomains', 'emc', 'databank', 'clinicient', 'leveleleven', 'findbetter', 'cielo', 'toast', 'innroad', 'savo', 'fuseuniversal', 'scholarswag', 'mongodb', 'insightsquared', 'klipfolio', 'northpoint', 'imginsiders', 'edmodo', 'gofmx', 'thepredictiveindex', 'parchment', 'rocketfuel', 'bankerstoolbox', 'demandgen', 'nutanix', 'clarizen', 'itominsiders', 'salesforce1platform', 'acronis', 'predixion', 'crimsonhexagon', 'nxtbookmedia', 'jda', 'demandbase', 'acquisio', 'atlassian', 'futuresuper', 'apprenda', 'neustar', 'fliptop', 'vip', 'verafin', 'homeaway', 'tcsociety', 'insightpool', 'linkedin', 'cielotalent', 'netscout', 'cox', 'cloudelements', 'frost', 'glowpoint', 'dexterchaney', 'nlyte', 'hirevue', 'bah', 'insidesales', 'covidien', 'gnapartners', 'gooddata', 'calabrio', 'on24', 'symantecgold', 'intronis', 'qualtrics', 'getcake', 'smartling', 'couch-associates', 'salesloft', 'trelora', 'bistromd', 'siia', 'safedose', 'bluecat', 'acton', 'gainsight', 'couchdb', 'vif', 'apttus', 'impactgroup', 'rolepoint', 'businessolver', 'rivs', 'egencia', 'ilabsmoney', 'skotidasconsulting', 'kareo', 'procurify', 'peoplematter', 'datadotcom', 'insperity', 'bbchampions', 'hubspot', 'windward', 'opendns', 'knowledgevision', 'credibly', 'gohubble', 'silanis', 'quantum', 'res', 'hostanalytics', 'distilnetworks', 'uberflip', 'ezidebit', 'salesforcedevs', 'firstround', 'okta', 'alfresco', 'trinet', 'insurity', 'reltio', 'sococo', 'pitneybowes', 'marketo', 'replicon', 'marketingcloud', 'heinzmarketing', 'monetate', 'trackmaven', 'myjeweller', 'g5', 'hpsweducation', 'openview', 'compliancescience', 'diligent', 'elitesem', 'asigra', 'fleetsharp', 'enterasys', 'bomgar', 'mhiglobal', 'sleetergroup', 'devmvp', 'paysimple', 'ppminsiders', 'kapost', 'mulesoft', 'dundas', 'victorops', 'bmc', 'montage', 'vidyard', 'theclub', 'deltek', 'grasshopper', 'talari', 'mavenlink', 'netbase', 'customerreferenceforum', 'onecallnow', 'litmos', 'cloudbees', 'asusitaly', 'contactatonce', 'blackduck', 'junctionsolutions', 'insideview', 'reflexis', 'carouselindustries', 'myemma', 'greenbiz', 'tintri', 'hiremojo', 'aconex', 'zerto', 'oraclesocial', 'talentwise', 'armanino', 'centrify', 'pinnacleprivatewealth', 'wiley', 'fonality', 'pedowitzgroup', 'applause', 'infusionsoft', 'myhealthop', 'prounlimited', 'genesys', 'raml', 'uptimesoftware', 'qvidian', 'saiglobal', 'looker', 'pingidentity', 'zscaler', 'netprospex', 'discoverorg', 'jumio', 'opensesame', 'messagesystems', 'hoopla', 'smarttech', 'liveramp', 'commonangels', 'bluewolf', 'strongview', 'bullhorn', 'deliciousliving', 'five9', 'eteacher', 'articulate-insiders', 'aciworldwide', 'zenpayroll-partner', 'mercurylabs', 'simplivity', 'brightpearl', 'inin', 'imanami', 'connectfirst', 'devolutions', 'icompass', 'stansberry', 'smashfly', 'moneytips', 'pgi')
    group by 1,2
  )
  select
    distinct created_date as month,
    median(sessions_count) over (partition by created_date) as median_admin_sessions_per_hub
  from session_count
  where created_date != to_char(getdate(), 'YYYY-MM')
) as session_count on event_count.month = session_count.month
order by 1 asc

-- Query logic
-- Take (median # events per hub) / (median admin sessions per hub) monthly

-- median events per hub monthly:
  select
    distinct created_date as month,
    median(events_count) over (partition by created_date) as median_event_count
  from 
  (
    select 
      to_char(e.created_at, 'YYYY-MM') as created_date, 
      subdomain, 
      count(e.id) as events_count
    from events e
    inner join companies co on e.company_id = co.id
    group by 1,2
  )
  order by 1 asc


-- median admin sessions per month
  with session_count as
  (
    select 
      to_char(s.created_at, 'YYYY-MM') as created_date, 
      subdomain, 
      count(s.id) as sessions_count
    from session_logs s
    inner join companies co on s.company_id = co.id
    inner join contacts c on s.contact_id = c.id
    where c.type = 'Corporate' and email not like '%influitive%'
    group by 1,2
  )
  select
    distinct created_date as month,
    median(sessions_count) over (partition by created_date) as median_admin_sessions_per_hub
  from session_count
  where created_date != to_char(getdate(), 'YYYY-MM')
  order by 1 asc 


-- ROARS SUBQUERY
-- MEDIAN ROAR_COUNT PER DAY SINCE IMPLEMENTATION 
with roar_count as
(
select 
  to_char(r.created_at, 'YYYY-MM-DD') as created_date, 
  subdomain, 
  count(r.id) as roars_count
from roars r
inner join companies co on r.company_id = co.id
group by 1, 2
order by created_date asc
)
select 
  distinct created_date as month,
  median(roars_count) over (partition by created_date) as median_roars_per_hub
from roar_count
where created_date != to_char(getdate(), 'YYYY-MM-DD')
order by 1 asc
)


select distinct cht.name
from events e
join challenges ch on e.challenge_id = ch.id
join challenge_types cht on ch.challenge_type_id = cht.id
where e.type = 'completed_challenge'
and cht.name like '%eview%'
or cht.name like '%efer%'
or cht.name like '%estimon%'
or cht.name like '%ase stud%'
or cht.name like '%ocial%'
or cht.name like '%acebook%'
or cht.name like '%inkedin%'
or cht.name like '%witter%'
or cht.name like '%uora%'
and cht.name not like '%Preview%'

select distinct cht.name from challenge_types cht



