/*
 * Copyright (c) 2022, NVIDIA CORPORATION. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *  * Neither the name of NVIDIA CORPORATION nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "benchmark_template_chunked.cuh"
#include "nvcomp/ans.h"

static const nvcompBatchedANSOpts_t nvcompBatchedANSOpts = {};

static bool handleCommandLineArgument(
    const std::string& arg,
    const char* const* additionalArgs,
    size_t& additionalArgsUsed)
{
  // There is an option, but the enum has only one value at the moment,
  // so it's not really an option.
  return false;
}

static bool isANSInputValid(const std::vector<std::vector<char>>& data)
{
  for (const auto& chunk : data) {
    if (chunk.size() > (1ULL << 32) - 1) {
      std::cerr << "ERROR: ANS doesn't support chunk sizes larger than "
                   "2^32-1 bytes."
                << std::endl;
      return false;
    }
  }

  return true;
}

void run_benchmark(
    const std::vector<std::vector<char>>& data,
    const bool warmup,
    const size_t count,
    const bool csv_output,
    const bool tab_separator,
    const size_t duplicate_count,
    const size_t num_files)
{
  run_benchmark_template(
      nvcompBatchedANSCompressGetTempSize,
      nvcompBatchedANSCompressGetMaxOutputChunkSize,
      nvcompBatchedANSCompressAsync,
      nvcompBatchedANSDecompressGetTempSize,
      nvcompBatchedANSDecompressAsync,
      isANSInputValid,
      nvcompBatchedANSOpts,
      data,
      warmup,
      count,
      csv_output,
      tab_separator,
      duplicate_count,
      num_files);
}
