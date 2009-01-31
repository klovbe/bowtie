/**
 * range.h
 */

#ifndef RANGE_H_
#define RANGE_H_

#include <vector>
#include <stdint.h>

/**
 * A range along with the alignment it represents.
 */
struct Range {
	uint32_t top;     // top of range
	uint32_t bot;     // bottom of range
	uint32_t stratum; // stratum
	uint32_t numMms;  // # mismatches
	std::vector<uint32_t> mms;   // list of positions with mismatches
	std::vector<uint8_t>  refcs; // reference characters at mismatch positions
	const Ebwt<seqan::String<seqan::Dna> > *ebwt;
};

#endif /* RANGE_H_ */