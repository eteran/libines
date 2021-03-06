/*
Copyright (C) 2000 - 2011 Evan Teran
                          eteran@alum.rit.edu

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifdef _MSC_VER
#pragma warning( disable : 4127 )
#endif

#include "lib_ines.h"

#include <assert.h>
#include <stdlib.h>
#include <string.h>

/*-----------------------------------------------------------------------------
// read_header_INES
//---------------------------------------------------------------------------*/
INES_RETURN_CODE read_header_INES(FILE *file, ines_header_t *header) {

	/* check pointers */
	assert(file != 0);
	assert(header != 0);

	/* header is ALWAYS at begining of file */
	rewind(file);

	/* read the header data */
	if(fread(header, 1, sizeof(ines_header_t), file) != sizeof(ines_header_t)) {
		return INES_READ_FAILED;
	}

	return INES_OK;
}

/*-----------------------------------------------------------------------------
// write_header_INES
//---------------------------------------------------------------------------*/
INES_RETURN_CODE write_header_INES(FILE *file, const ines_header_t *header) {
	/* check pointers */
	assert(file != 0);
	assert(header != 0);

	/* header is ALWAYS at begining of file */
	rewind(file);

	/* write the header data */
	if(fwrite(header, 1, sizeof(ines_header_t), file) != sizeof(ines_header_t)) {
		return INES_WRITE_FAILED;
	}

	return INES_OK;
}

/*-----------------------------------------------------------------------------
// check_header_INES
//---------------------------------------------------------------------------*/
INES_RETURN_CODE check_header_INES(const ines_header_t *header, int version) {

	assert(header != 0);

	if(memcmp(header->ines_signature, "NES\x1a", 4) != 0) {
		return INES_BAD_HEADER;
	}

	if(version != 2) {
		if(header->extended.ines1.reserved_2 != 0 || header->extended.ines1.reserved_1 != 0) {
			return INES_DIRTY_HEADER;
		}
	}

	return INES_OK;
}
