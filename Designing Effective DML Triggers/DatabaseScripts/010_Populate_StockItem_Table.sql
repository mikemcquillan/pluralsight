SELECT 'INSERT INTO dbo.StockItem (Title, [Format], Publisher, Media, YearReleased, Condition, ReleaseType, ItemType, [Case], [Description], ItemCode, StockLevel, BasePrice) VALUES (' +
	'''' + REPLACE(Title, '''', '''''') + ''', ' +
	CASE COALESCE([Format], '') WHEN '' THEN 'NULL, ' ELSE '''' + [Format] + ''', ' END +
	CASE COALESCE(Publisher, '') WHEN '' THEN 'NULL, ' ELSE '''' + REPLACE(Publisher, '''', '''''') + ''', ' END + 
	CASE COALESCE(Media, '') WHEN '' THEN 'NULL, ' ELSE '''' + Media + ''', ' END + 
	CASE COALESCE(YearReleased, 0) WHEN 0 THEN 'NULL, ' ELSE CONVERT(VARCHAR(4), YearReleased) + ', ' END + 
	CASE COALESCE(Condition, '') WHEN '' THEN 'NULL, ' ELSE '''' + Condition + ''', ' END + 
	CASE COALESCE(ReleaseType, '') WHEN '' THEN 'NULL, ' ELSE '''' + ReleaseType + ''', ' END +
	CASE COALESCE(ItemType, '') WHEN '' THEN 'NULL, ' ELSE '''' + ItemType + ''', ' END + 
	CASE COALESCE([Case], '') WHEN '' THEN 'NULL, ' ELSE '''' + [Case] + ''', ' END +
	CASE COALESCE([Description], '') WHEN '' THEN 'NULL, ' ELSE '''' + REPLACE([Description], '''', '''''') + ''', ' END +
	CASE COALESCE(ItemCode, '') WHEN '' THEN 'NULL, ' ELSE '''' + ItemCode + ''', ' END +
	CONVERT(VARCHAR(10), StockLevel) + ', ' +
	CONVERT(VARCHAR(10), BasePrice) + 
	')' AS [InsertQuery]
FROM StockItem;
