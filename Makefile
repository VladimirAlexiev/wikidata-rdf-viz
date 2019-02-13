IGNORE = prefixes.ttl
TTL    = $(filter-out $(IGNORE), $(wildcard *.ttl))
PNG    = $(patsubst %.ttl, %.png, $(TTL))
SVG    = $(patsubst %.ttl, %.svg, $(TTL))

all : $(PNG) $(SVG)

%.puml : %.ttl
	rdfpuml.bat $<

%.png : %.puml
	puml.bat $<

%.svg : %.puml
	puml.bat -tsvg $<

