Tactical.lutro:
	zip -9 -r Tactical.lutro ./*

Tactical.js:
	python3 ~/emsdk/upstream/emscripten/tools/file_packager.py Tactical.data --preload . --js-output=Tactical.js

clean:
	@$(RM) -f Tactical.*

.PHONY: all clean
