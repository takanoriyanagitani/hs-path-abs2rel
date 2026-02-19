FROM haskell:9.12.2-slim-bookworm AS builder
RUN echo cabal update date: 2026-01-05
RUN cabal update --verbose=2

WORKDIR /hs-path-abs2rel
COPY --link ./hs-path-abs2rel.cabal ./
RUN cabal update --verbose=2
RUN cabal build --only-dependencies
COPY --link ./app/ ./app/
COPY --link ./src/ ./src/
COPY --link ./LICENSE ./
RUN cabal build
RUN cp $( cabal list-bin hs-path-abs2rel | fgrep --max-count=1 hs-path-abs2rel ) /usr/local/bin/
RUN which hs-path-abs2rel

FROM debian:bookworm-slim
COPY --link --from=builder /usr/local/bin/hs-path-abs2rel /usr/local/bin/

CMD ["/usr/local/bin/hs-path-abs2rel"]
