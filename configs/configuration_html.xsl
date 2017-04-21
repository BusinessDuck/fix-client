<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns="http://www.w3.org/1999/xhtml">

	<xsl:output encoding="UTF-8" method="html" indent="yes"/>

	<xsl:key name="FeedTypes" match="/configuration/MarketDataGroup" use="@feedType"/>
	<xsl:key name="marketIDs" match="/configuration/MarketDataGroup" use="@marketID"/>

	<xsl:template match="/configuration">
	
		<html>
			<head>
				<title>MOEX Market Data Platform current configuration</title>
				<style type="text/css">
					body {
						font: 76% Verdana, Geneva, Arial, Helvetica, sans-serif;
						text-align: left;
						line-height: 1em;
						color: #333
					}

					a, a:link, a:active {
						background: white;
						text-decoration: underline;
						color: blue
					}

					a:visited {
						background: transparent;
						color: purple
					}

					a:hover {
						background: black;
						text-decoration: none;
						color: white
					}

					h1 {
						font-size: 2em;
						margin: 0 0 0.5em 0;
						padding: 0;
						line-height: 1.5em;
						color: black
					}

					h2 {
						font-size: 1.5em;
						margin: 0 0 0.5em 0;
						padding: 0;
						line-height: 1.5em;
						color: black
					}

					h3 {
						font-size: 1.3em;
						margin: 0 0 0.5em 0;
						padding: 0;
						line-height: 1.3em;
						color: black
					}

					h4 {
						font-size: 1.2em;
						margin: 0 0 0.25em 0;
						padding: 0;
						line-height: 1.3em;
						color: black
					}

					h5 {
						font-size: 1.1em;
						margin: 0 0 0.25em 0;
						padding: 0;
						line-height: 1.3em;
						color: black
					}

					h6 {
						font-size: 1em;
						margin: 0 0 0.25em 0;
						padding: 0;
						line-height: 1.3em;
						color: black
					}

					p {
						font-size: 1em;
						margin: 0 0 1.5em 0;
						padding: 0;
						line-height: 1.4em
					}

					blockquote {
						margin-left: 10px;
						border-left: 10px solid #ddd
					}

					pre {
						font: 1.0em monospace
					}

					strong, b {
						font-weight: bold
					}

					em, i {
						font-style: italic
					}

					code {
						font: 1em "Courier New", Courier, monospace;
						white-space: pre
					}

					table {
						font-size: 1em;
						margin: 0 0 1.5em 0;
						padding: 0
					}

					table caption {
						font-weight: bold;
						margin: 0;
						padding: 0 0 1.5em 0
					}

					th {
						font-weight: bold;
						text-align: left
					}

					td {
						font-size: 1em
					}

					table {
						border-collapse: collapse
					}

					table th, table td {
						border: 1px solid #ccc;
						padding: 2px 3px;
						vertical-align: top
					}

					table th {
						background: #f4f4f4
					}

					body {
						font: 76% Verdana, Geneva, Arial, Helvetica, sans-serif;
						text-align: left;
						line-height: 1em;
						color: #333
					}

					table#overview   th {
						background-color: #9cf;
					}

					table#overview   td {
						padding: 10px 3px;
					}

					a.cell {
						display: block;
					}

					div.gray {
						color: #777;
						font-weight: 100;
					}

				</style>
			</head>

			<body style="padding: 0.5cm; padding-top: 1cm">
				<h2>Market Data Groups</h2>

						<xsl:for-each
								select="/configuration/MarketDataGroup[generate-id(.) = generate-id(key('marketIDs', @marketID))]">
							<xsl:variable name="marketID" select="@marketID"/>

								<h3>
									<xsl:call-template name="marketID">
										<xsl:with-param name="marketID" select="$marketID"/>
									</xsl:call-template>
								</h3>

								<xsl:for-each
										select="/configuration/MarketDataGroup[generate-id(.) = generate-id(key('FeedTypes', @feedType))]">
									<xsl:variable name="feedType" select="@feedType"/>

										<xsl:for-each
												select="/configuration/MarketDataGroup[@feedType=$feedType][@marketID=$marketID]">
											<xsl:call-template name="Cell"/>
										</xsl:for-each>
								</xsl:for-each>
              <p style="height: 0.1cm"/>
            
						</xsl:for-each>

				<hr/>

				<h2>Connection Details:</h2>
				<xsl:for-each select="MarketDataGroup">
					<h3>
						<xsl:value-of select="position()"/><xsl:text>. </xsl:text>
						<a name="{@feedType}-{@marketID}"></a>
						<xsl:value-of select="@label"/>
					</h3>

					Details:
					<table border="0">
						<xsl:for-each select="@*">
							<tr>
								<td>
									<xsl:value-of select="name()"/>
								</td>
								<td>
									<strong>
										<xsl:value-of select="."/>
									</strong>
								</td>
							</tr>
						</xsl:for-each>
					</table>

					Connections:
					<table border="1" width="500px">
						<thead>
							<tr>
								<th>Connection type</th>
								<th>Source address</th>
								<th colspan="3">Address</th>
								<th>Max. kbps</th>
							</tr>
						</thead>
						<tbody>
							<xsl:for-each select="connections/connection">
								<xsl:call-template name="Connection"/>
							</xsl:for-each>
						</tbody>
					</table>

					<hr/>

				</xsl:for-each>

				<div class="gray">(End of document)</div>
				<p style="height: 700px"/>
			</body>

		</html>

	</xsl:template>

	<xsl:template name="Connection">
		<tr>
			<td>
				<xsl:value-of select="type"/>
				<xsl:if test="feed">
					<span style="color: darkgray;">
						<xsl:text> feed </xsl:text>
						<xsl:value-of select="feed"/>
					</span>
				</xsl:if>
			</td>
			<td>
				<xsl:value-of select="src-ip"/>
			</td>
			<td>
				<xsl:value-of select="protocol"/>
			</td>
			<td>
				<xsl:value-of select="ip"/>
			</td>
			<td>
				<xsl:value-of select="port"/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="maxKbps!=0">
						<xsl:value-of select="maxKbps"/>
					</xsl:when>
					<xsl:when test="maxKbps=0">
						<xsl:text> unlimited </xsl:text>
					</xsl:when>
					<xsl:when test="type='Incremental'">
						<xsl:for-each select="ancestor::configuration/ConfigTemplates/connection">
							<xsl:if test="type='Incremental'">
								<xsl:call-template name="MaxKbps"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="type='Snapshot'">
						<xsl:for-each select="ancestor::configuration/ConfigTemplates/connection">
							<xsl:if test="type='Snapshot'">
								<xsl:call-template name="MaxKbps"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text> unlimited </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

	<xsl:template name="MaxKbps">
		<xsl:choose>
			<xsl:when test="maxKbps!=0">
				<xsl:value-of select="maxKbps"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> unlimited </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="Cell">
		<a href="#{@feedType}-{@marketID}" class="cell">
			<xsl:value-of select="@label"/>
    </a>
	</xsl:template>

	<xsl:template name="FeedType">
		<xsl:param name="feedType"/>
		<div title="FeedType={$feedType}">
			<xsl:choose>
				<xsl:when test="$feedType = 'ORDERS'">Full order book</xsl:when>
				<xsl:when test="$feedType = 'FUT-BOOK-50'">Market depth</xsl:when>
				<xsl:when test="$feedType = 'OPT-BOOK-50'">Market depth</xsl:when>
				<xsl:when test="$feedType = 'FUT-BOOK-20'">Market depth</xsl:when>
				<xsl:when test="$feedType = 'OPT-BOOK-20'">Market depth</xsl:when>
				<xsl:when test="$feedType = 'FUT-BOOK-5'">Market depth</xsl:when>
				<xsl:when test="$feedType = 'OPT-BOOK-5'">Market depth</xsl:when>
				<xsl:when test="$feedType = 'FUT-BOOK-1'">Top of book</xsl:when>
				<xsl:when test="$feedType = 'OPT-BOOK-1'">Top of book</xsl:when>
				<xsl:when test="$feedType = 'FUT-INFO'">Instrument Definition</xsl:when>
				<xsl:when test="$feedType = 'OPT-INFO'">Instrument Definition</xsl:when>
				<xsl:when test="$feedType = 'FUT-TRADES'">Trades &amp; Fundamentals</xsl:when>
				<xsl:when test="$feedType = 'OPT-TRADES'">Trades &amp; Fundamentals</xsl:when>
				<xsl:when test="$feedType = 'NEWS'">News</xsl:when>
				<xsl:when test="$feedType = 'INDEX'">Indexes</xsl:when>
				<xsl:when test="$feedType = 'NEWS-SKRIN'">News</xsl:when>
				<xsl:when test="$feedType = 'OTC-ISSUES'">Instrument Definition</xsl:when>
				<xsl:when test="$feedType = 'OTC-TRADES'">Trades</xsl:when>
				<xsl:otherwise>
					Custom Feed Type
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<div class="gray">
			<xsl:value-of select="$feedType"/>
		</div>
	</xsl:template>
	<xsl:template name="marketID">
		<xsl:param name="marketID"/>
		<div title="MerketSegment id='{$marketID}'">
			<xsl:choose>
				<xsl:when test="$marketID = 'F'">Futures</xsl:when>
				<xsl:when test="$marketID = 'O'">Options</xsl:when>
				<xsl:when test="$marketID = 'I'">Indexes</xsl:when>
				<xsl:when test="$marketID = 'N'">News</xsl:when>
				<xsl:when test="$marketID = 'Q'">OTC</xsl:when>
				<xsl:when test="$marketID = 'S'">MOEX Board</xsl:when>
				<xsl:otherwise>
					Custom segment
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
</xsl:stylesheet>