get_news_api_key() { cat "${HOME}/root/work/record/pc/account/newsapikey"; }
get_news_api_url() {
	local url="https://newsapi.org/v2/top-headlines"
	url+="?country=jp"
	url+="&pageSize=100"
	[ -n "$1" ] && url+="&category=${1}"
	echo "$url"
}
get_news_categolies() { echo "general technology science business health"; }
#news_categolies() { echo "general technology science business health entertainment sports"; }
#news_categolies() { echo "business entertainment general health science sports technology"; }
request() { curl ${1} -H "X-Api-Key:${NEWS_API_KEY:-"`get_news_api_key`"}"; }
format_json() {
	local name="_`basename "$1"`"
	cat "$1" | python3 -c 'import sys,json;print(json.dumps(json.loads(sys.stdin.read()),indent=4,ensure_ascii=False))' > "${name}"
}
get_news() {
	local now="`date +"%Y%m%d%H%M%S"`"
	for categoly in `get_news_categolies`; do
		local url="`get_news_api_url ${categoly}`"
		request "${url}" > "${now}_${categoly}.json"
		format_json > "${now}_${categoly}.json"
		sleep 1;
	done
}
get_news

