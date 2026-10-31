/*
 * Tested with typst 0.15.1
 */

#import "@preview/chronos:0.3.0"

#let GLOBAL_BLOCK_FILL  = rgb(50, 50, 50)
#let GLOBAL_BLOCK_INSET = 8pt
#let GLOBAL_TEXT = rgb(230, 230, 230)
#let GLOBAL_PAGE_FILL = rgb(20, 20, 20)

#set document(
  title: [Username-less Passkey Auth],
  author: "John Doe",
  date: datetime(year: 2026, month: 2, day: 1),
)
#set text(lang: "en")
#set page(fill: GLOBAL_PAGE_FILL)
#set text(fill: GLOBAL_TEXT)
#set heading(numbering: "1.1")

#title()

#context document.author.join(", "), #context document.date.display("[year]-[month]-[day]")

#outline()

#pagebreak()
= Overview

#table(
  columns: 4,
  [*component*],
  [*name*],
  [*version*],
  [*notes*],

  [server library],
  [_webauthn-rs_],
  [`0.5.4`#footnote[
    https://docs.rs/webauthn-rs/0.5.4/webauthn_rs/index.html
    (accessed 2026-02-01)
  ]],
  [Latest as of 2026-02-01.],

  [client web browser],
  [_Brave_],
  [`1.86.146`],
  [Latest as of 2026-02-01.],

  [client OS],
  [_Windows 11_],
  [`25H2`#footnote[
    Edition Windows 11 Home,
    Version 25H2,
    OS build 26200.7623,
    Experience Windows Feature Experience Pack 1000.26100.275.0
  ]],
  [],
)

Example citations: an article @zhao2026c2rust and a website
@cloudflare-radar-8888. Example citation with specific page. @zhao2026c2rust[p. 5]

@fig-passkey-create-and-register-overview approximates passkey creation process
steps on a high level. @fig-passkey-create-and-register-detailed depicts the
process in more detail. @lst-start-registration shows how the server starts the
registration with _webauthn-rs_.

#block(breakable: false)[
  #figure(
      chronos.diagram({
        chronos._par("os", display-name: "OS Passkey Store", color: GLOBAL_BLOCK_FILL)
        chronos._par("browser", display-name: "Web Browser Client", color: GLOBAL_BLOCK_FILL)
        chronos._par("server", display-name: "Server", color: GLOBAL_BLOCK_FILL)

        chronos._seq("browser", "server", comment: [
          *\#1*\
          Client requests parameters for\
          creating a passkey from server.
        ])

        chronos._note("over", [
          *\#2*\
          Server determines what parameters\
          to use and stores a corresponding\
          transaction in its state to be\
          finalized later.
        ], pos: "server", color: GLOBAL_PAGE_FILL)

        chronos._seq("server", "browser", comment: [
          *\#3*\
          Passkey creation parameters and\
          a reference to the transaction in\
          progress.
        ])

        chronos._note("over", [
          *\#4*\
          Call the OS's passkey store for\
          creating a passkey.
        ], pos: "browser", color: GLOBAL_PAGE_FILL)

        chronos._seq("browser", "os", comment: [
          *\#5*\
        ])
      }),
    caption: [Overview of creating a passkey.],
  ) <fig-passkey-create-and-register-overview>
]

#block(breakable: false)[
  #figure(
      chronos.diagram({
        chronos._par("os", display-name: "OS Passkey Store", color: GLOBAL_BLOCK_FILL)
        chronos._par("browser", display-name: "Web Browser Client", color: GLOBAL_BLOCK_FILL)
        chronos._par("server", display-name: "Server", color: GLOBAL_BLOCK_FILL)

        chronos._seq("browser", "server", comment: [
          *\#1*\
          Client requests parameters for\
          creating a passkey from server.
          ```http
          POST /api/v1/key/create/init
          ```
        ])

        chronos._note("over", [
          *\#2*\
          Server determines what parameters\
          to use and stores a corresponding\
          transaction in its state to be\
          finalized later.#footnote[
            https://docs.rs/webauthn-rs/0.5.4/webauthn_rs/struct.Webauthn.html#method.start_passkey_registration
            (accessed 2026-02-01)
          ]
          ```rust
          // webauthn-rs
          start_passkey_registration();
          ```
        ], pos: "server", color: GLOBAL_PAGE_FILL)

        chronos._seq("server", "browser", comment: [
          *\#3*\
          Passkey creation parameters and\
          a reference to the transaction in\
          progress.
          ```http
          200 OK
          Content-Type: application/json

          {
            "transaction_id": "abcd1234",
            "params": { }
          }
          ```
        ])

        chronos._note("over", [
          *\#4*\
          Call the OS's passkey store for\
          creating a passkey.#footnote[
            https://developer.mozilla.org/en-US/docs/Web/API/CredentialsContainer/create
            (accessed 2026-02-01)
          ]
          ```javascript
          await navigator
            .credentials
            .create();
          ```
        ], pos: "browser", color: GLOBAL_PAGE_FILL)

        chronos._seq("browser", "os", comment: [
          *\#5*\
        ])
      }),
    caption: [Creating a passkey.],
  ) <fig-passkey-create-and-register-detailed>
]

#figure(
  kind: raw,
  block(fill: GLOBAL_BLOCK_FILL, inset: GLOBAL_BLOCK_INSET, width: 100%, align(left)[
    ```rust
    fn start_registration(webauthn: &Webauthn, user_id: Uuid) {
        let (challenge, state) = webauthn
            .start_passkey_registration(user_id, "john", "John Doe", None)
            .expect("failed to start registration");
    }
    ```
  ]),
  caption: [Starting a passkey registration.],
) <lst-start-registration>

#pagebreak()
#bibliography(
  bytes(```yaml
zhao2026c2rust:
  type: Article
  title: "Fine-Tuning Qwen3-27B for C-to-Rust Code Translation: A Three-Stage Curriculum of Pretraining, Debugging-Aware SFT, and Task-Specific SFT"
  author:
    - Zhao, Pu
    - Yang, Changdi
    - Chen, Yixiao
    - Gao, Yi
    - Cao, Yifan
    - Zeng, Haochen
    - Wang, Yanzhi
  date: 2026-08-13
  serial-number:
    arxiv: "2608.13681"
  url: https://arxiv.org/abs/2608.13681

cloudflare-radar-8888:
  type: Web
  title: "Cloudflare Radar: IP address 8.8.8.8"
  author: Cloudflare
  url:
    value: https://radar.cloudflare.com/ip/8.8.8.8
    date: 2026-10-24
```.text),
  style: "ieee",
)
