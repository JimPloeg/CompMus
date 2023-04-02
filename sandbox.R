library(tidyverse)
library(spotifyr)
library(compmus)
library(plotly)


martinGarrix <- get_playlist_audio_features("", "37i9dQZF1DX94qaYRnkufr") |>
  slice(1:30) |>
  add_audio_analysis()

shingoNakamura <- get_playlist_audio_features("", "37i9dQZF1DZ06evO31dbFf") |>
  slice(1:30) |>
  add_audio_analysis()

tempo_comparison <-
  martinGarrix |>
  mutate(artist = "Martin Garrix") |>
  bind_rows(shingoNakamura |> mutate(artist = "Shingo Nakamura"))


graph <- tempo_comparison %>%
  mutate(
    sections =
      map(
        sections,                                    # sections or segments
        summarise_at,
        vars(tempo, loudness, duration),             # features of interest
        list(section_mean = mean, section_sd = sd)   # aggregation functions
      )
  ) |>
  unnest(sections) |>
  ggplot(
    aes(
      x = tempo,
      y = duration / 60,
      colour = artist
    )
  ) +
  geom_point() +
  geom_rug() +
  theme_minimal() +
  ylim(0, 5) +
  labs(
    x = "Mean Tempo (bpm)",
    y = "Duration",
    colour = "Artist"
  )

ggplotly(graph)
