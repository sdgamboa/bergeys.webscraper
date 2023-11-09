
Use command below to save links of genera to txt

```bash
strings bergeys_2023-11-09.pdf | grep -o -e http.*gbm.*abstract | sort > genera_abstract_links.txt
```
