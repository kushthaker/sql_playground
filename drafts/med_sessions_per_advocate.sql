-- MEDIAN SESSIONS PER ADVOCATE MONTHLY
-- method 1: totals
select 
  to_char(session_logs.created_at, 'YYYY-MM') as month,
  -- count(session_logs.id)::float as sessions_count,
  -- count(distinct contacts.id)::float contacts_count,
  (count(session_logs.id)::float / count(distinct contacts.id)::float) as sessions_per_advocate
from session_logs
left join contacts on session_logs.contact_id = contacts.id
where contacts.type = 'Advocate' 
AND to_char(session_logs.created_at, 'YYYY-MM') != to_char(getdate(), 'YYYY-MM')
AND session_logs.id IS NOT NULL
group by 1
order by 1 asc

-- MEDIAN SESSIONS PER ADVOCATE MONTHLY
-- method 2: ratio of medians
with sessions_advocates_table as
(
  select 
    to_char(session_logs.created_at, 'YYYY-MM') as created_date,
    subdomain,
    count(distinct session_logs.id)::float as sessions_count,
    count(DISTINCT contacts.id)::float as advocates_count
  from session_logs
  left join contacts on session_logs.contact_id = contacts.id
  inner join companies on session_logs.company_id  = companies.id
  where contacts.type = 'Advocate' 
  AND to_char(session_logs.created_at, 'YYYY-MM') != to_char(getdate(), 'YYYY-MM')
  AND session_logs.id IS NOT NULL
  and subdomain in ('mobify', 'adeptia', 'seismic', 'envoy', 'modeln', 'samanage', 'hireright', '15five', 'siriusdecisions', 'maxsold', 'ecobee', 'touchbistro', 'onelogin', 'qlik', 'skyhighnetworks', 'evault', 'ultimatesoftware', 'echosign', 'esiinternational', 'leonardo', 'creationagency', 'shoretel', 'snacknation', 'cco', 'amtdirect', 'computersupport', 'salesforcepremier', 'smartenterprise', 'liaison', 'predictablerevenue', 'saucelabs', 'zama', 'recruitloop', 'druva', 'ektron', 'liveintent', 'joinme', 'on-site', 'plangrid', 'eventboard', 'pointdrive', 'fisherbioservices', 'ibmhybridcloud', 'mindjet', 'keepersecurity', 'vsl3', 'totango', 'forrester', 'aerohive', 'staples', 'xactly', 'connectandsell', 'iovation', 'kontagent', 'turnto', 'arrowecs', 'inkling', 'firstcal', 'membersolutions', 'coupa', 'opsbridgeinsiders', 'boomtown', 'epn', 'demandspring', 'conga', 'invoca', 'intalio', 'marketbridge', 'owncloud', 'loopup', 'revegy', 'glasscubes', 'nginx', 'lotame', 'whitlock', 'homestars', 'pgisales', 'clearslide', 'acquia', 'brainshark', 'zeroturnaround', 'eloqua', 'ocz', 'herok12', 'pulsesecure', 'arrowsi', 'ironmountain', 'forcepoint', 'springcm', 'astutesolutions', 'twitter', 'recombo', 'signatureworldwide', 'kissmetrics', 'shareologybook', 'clearcare', 'worketc', 'doubledutch', 'pardot', 'tribehr', 'vpprn', 'nwnit', 'blackline', 'billdotcom', 'smartthings', 'zenpayroll', 'firmex', 'pearson', 'verint', 'tagetik', 'datawatch', 'box', 'purestorage', 'anaplan', 'avalara', 'esker', 'apriori', 'ibmchampion', 'communityforce', 'learncore', 'schooladmin', 'ringcentral', 'watsonhealth', 'apminsiders', 'nitro', 'relayventures', 'clari', 'tangocard', 'code42software', 'fnts', 'kiratalent', 'hootsuite', 'neopost', 'socrata', 'hpadm', 'kace', 'zapproved', 'reviewsnap', 'riseinteractive', 'adaptiveinsights', 'zend', 'genologics', 'sas', 'acst', 'logmein', 'epicorsoftware', 'clearfit', 'netfactor', 'ibm', 'cija', 'billtrust', 'buffini', 'attask', 'cloudwords', 'cloudon', 'termsync', 'jwplayer', 'cvent', 'vht', 'acmcommunity', 'kubotek', 'desk', 'readytalk', 'semrush', 'adar', 'apigee', 'metaswitch', 'nexmo', 'tripleseat', 'swarm', 'veracode', 'paychex', 'mogiv', 'unitrends', 'xcmsolutions', 'intuitquickbase', 'adp', 'rapid7', 'adsensa', 'mitel', 'conductor', 'docusign', 'easycleanenergy', 'quorum', 'wegohealth', 'evolveip', 'blackberry', 'riverbed', 'bluemix', 'freshbooks', 'eastwick', 'limelight', 'macadamian', 'selectica', 'aryaka', 'ourcrowd', 'gochrysalis', 'datanauts', 'dyn', 'ceridian', 'sdl', 'nanawall', 'hortonworks', 'infoblox', 'skulpt', 'spiceworks', 'leadpages', 'cheebachews', 'namely', 'optimizely', 'tophat', 'hatchbuck', 'allocadia', 'acl', 'engineyard', 'transfast', 'smartbear', '1stlightenergy', 'socialimprints', 'appneta', 'bronto', 'dashlane', 'dynatrace', 'halogen', 'actuate', 'wrike', 'prnewswire', 'virginpulse', 'crazydomains', 'emc', 'databank', 'clinicient', 'leveleleven', 'findbetter', 'cielo', 'toast', 'innroad', 'savo', 'fuseuniversal', 'scholarswag', 'mongodb', 'insightsquared', 'klipfolio', 'northpoint', 'imginsiders', 'edmodo', 'gofmx', 'thepredictiveindex', 'parchment', 'rocketfuel', 'bankerstoolbox', 'demandgen', 'nutanix', 'clarizen', 'itominsiders', 'salesforce1platform', 'acronis', 'predixion', 'crimsonhexagon', 'nxtbookmedia', 'jda', 'demandbase', 'acquisio', 'atlassian', 'futuresuper', 'apprenda', 'neustar', 'fliptop', 'vip', 'verafin', 'homeaway', 'tcsociety', 'insightpool', 'linkedin', 'cielotalent', 'netscout', 'cox', 'cloudelements', 'frost', 'glowpoint', 'dexterchaney', 'nlyte', 'hirevue', 'bah', 'insidesales', 'covidien', 'gnapartners', 'gooddata', 'calabrio', 'on24', 'symantecgold', 'intronis', 'qualtrics', 'getcake', 'smartling', 'couch-associates', 'salesloft', 'trelora', 'bistromd', 'siia', 'safedose', 'bluecat', 'acton', 'gainsight', 'couchdb', 'vif', 'apttus', 'impactgroup', 'rolepoint', 'businessolver', 'rivs', 'egencia', 'ilabsmoney', 'skotidasconsulting', 'kareo', 'procurify', 'peoplematter', 'datadotcom', 'insperity', 'bbchampions', 'hubspot', 'windward', 'opendns', 'knowledgevision', 'credibly', 'gohubble', 'silanis', 'quantum', 'res', 'hostanalytics', 'distilnetworks', 'uberflip', 'ezidebit', 'salesforcedevs', 'firstround', 'okta', 'alfresco', 'trinet', 'insurity', 'reltio', 'sococo', 'pitneybowes', 'marketo', 'replicon', 'marketingcloud', 'heinzmarketing', 'monetate', 'trackmaven', 'myjeweller', 'g5', 'hpsweducation', 'openview', 'compliancescience', 'diligent', 'elitesem', 'asigra', 'fleetsharp', 'enterasys', 'bomgar', 'mhiglobal', 'sleetergroup', 'devmvp', 'paysimple', 'ppminsiders', 'kapost', 'mulesoft', 'dundas', 'victorops', 'bmc', 'montage', 'vidyard', 'theclub', 'deltek', 'grasshopper', 'talari', 'mavenlink', 'netbase', 'customerreferenceforum', 'onecallnow', 'litmos', 'cloudbees', 'asusitaly', 'contactatonce', 'blackduck', 'junctionsolutions', 'insideview', 'reflexis', 'carouselindustries', 'myemma', 'greenbiz', 'tintri', 'hiremojo', 'aconex', 'zerto', 'oraclesocial', 'talentwise', 'armanino', 'centrify', 'pinnacleprivatewealth', 'wiley', 'fonality', 'pedowitzgroup', 'applause', 'infusionsoft', 'myhealthop', 'prounlimited', 'genesys', 'raml', 'uptimesoftware', 'qvidian', 'saiglobal', 'looker', 'pingidentity', 'zscaler', 'netprospex', 'discoverorg', 'jumio', 'opensesame', 'messagesystems', 'hoopla', 'smarttech', 'liveramp', 'commonangels', 'bluewolf', 'strongview', 'bullhorn', 'deliciousliving', 'five9', 'eteacher', 'articulate-insiders', 'aciworldwide', 'zenpayroll-partner', 'mercurylabs', 'simplivity', 'brightpearl', 'inin', 'imanami', 'connectfirst', 'devolutions', 'icompass', 'stansberry', 'smashfly', 'moneytips', 'pgi')
  group by 1,2
  order by 1 asc
)
select
  distinct created_date,
  -- median(sessions_count) over (partition by created_date) as median_sessions_count,
  -- median(advocates_count) over (partition by created_date) as median_advocates_count,
  median(sessions_count) over (partition by created_date)/median(advocates_count) over (partition by created_date) as median_sessions_per_advocate
from sessions_advocates_table
order by 1 asc