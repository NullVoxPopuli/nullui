import "ember-mobile-menu/themes/android";

import { on } from "@ember/modifier";

import { pascalCase, sentenceCase } from "change-case";
// @ts-expect-error no types for the mobile-menu
import MenuWrapper from "ember-mobile-menu/components/mobile-menu-wrapper";
import { pageTitle } from "ember-page-title";
import Route from "ember-route-template";
import { PageNav } from "kolay/components";

import { ExternalLink, Header, Shell, ThemeToggle } from "#src/index.ts";
import { abbreviatedSha } from "~build/git";

import type { TOC } from "@ember/component/template-only";
import type { Page } from "kolay";

const Menu: TOC<{ Element: SVGElement }> = <template>
  <svg
    xmlns="http://www.w3.org/2000/svg"
    x="0px"
    y="0px"
    viewBox="0 0 50 50"
    style="fill:currentColor"
    ...attributes
  ><path
      d="M 0 7.5 L 0 12.5 L 50 12.5 L 50 7.5 Z M 0 22.5 L 0 27.5 L 50 27.5 L 50 22.5 Z M 0 37.5 L 0 42.5 L 50 42.5 L 50 37.5 Z"
    ></path></svg>
</template>;

const SideNav: TOC<{ Element: HTMLElement }> = <template>
  <aside>
    <PageNav ...attributes>
      <:page as |x|>
        <x.Link>
          {{nameFor x.page}}
        </x.Link>
      </:page>
      <:collection as |x|>
        {{#if x.index}}
          <x.index.Link>
            {{sentenceCase x.collection.name}}
          </x.index.Link>
        {{else}}
          {{sentenceCase x.collection.name}}
        {{/if}}
      </:collection>
    </PageNav>
  </aside>
</template>;

export default Route(
  <template>
    <Shell>
      {{pageTitle "Docs :: " abbreviatedSha}}

      <MenuWrapper as |mmw|>
        <mmw.MobileMenu @mode="push" @maxWidth={{200}} as |mm|>
          <SideNav {{on "click" mm.actions.close}} />
        </mmw.MobileMenu>

        <mmw.Content class="container">
          <Header>
            <:left>
              <mmw.Toggle><Menu /></mmw.Toggle>
              <a href="/">null.ui</a>
            </:left>
            <:right>
              <ExternalLink href="https://github.com/NullVoxPopuli/nullui">GitHub</ExternalLink>
              <ThemeToggle />
            </:right>
          </Header>

          <div class="big-layout">
            <SideNav />

            <main style="padding-top: 1rem;">
              {{outlet}}
            </main>
          </div>
        </mmw.Content>
      </MenuWrapper>
    </Shell>

    <style>
      .mobile-menu-wrapper {
        height: 100dvh;
        overflow: auto;
      }
      .mobile-menu-wrapper__content,
      .mobile-menu__tray {
        background: none;
      }

      header button.mobile-menu__toggle {
        padding: 0.25rem 0.5rem;
        background: none;
        color: currentColor;
        width: 48px;
        height: 44px;
        display: inline-flex;
        align-self: center;
        align-items: center;
        justify-content: center;
        margin: 0;
      }

      @media (min-width: 768px) {
        header button.mobile-menu__toggle {
          display: none;
        }
      }

      @media (max-width: 768px) {
        .big-layout aside {
          display: none;
        }
      }

      .big-layout {
        display: grid;
        grid-template-columns: max-content 1fr;
        gap: 2rem;

        main {
          max-width: 100dvw;
          padding: 1.5rem;
          display: flex;
          flex-direction: column;
          overflow-x: hidden;
        }
      }

      .mobile-menu__tray,
      .big-layout {
        overflow-x: hidden;

        nav {
          ul {
            padding-left: 0.5rem;
            list-style: none;
            line-height: 1.75rem;
          }
        }
      }
    </style>
  </template>,
);

function nameFor(x: Page) {
  // We defined componentName via json file

  if ("componentName" in x) {
    return `${x.componentName as string}`;
  }

  if (x.path.includes("/components/")) {
    return `<${pascalCase(x.name)} />`;
  }

  return sentenceCase(x.name);
}
