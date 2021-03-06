package lando.systems.ld35;

import com.badlogic.gdx.ApplicationAdapter;
import com.badlogic.gdx.Gdx;
import lando.systems.ld35.screens.BaseScreen;
import lando.systems.ld35.screens.MenuScreen;
import lando.systems.ld35.utils.Assets;

public class LudumDare35 extends ApplicationAdapter {

    public static LudumDare35 game;

    public BaseScreen screen;

    @Override
    public void create() {
        Assets.load();
        float progress = 0f;
        do {
            progress = Assets.update();
        } while (progress != 1f);
        screen = new MenuScreen();
        game = this;
    }

    @Override
    public void resume() {
        Assets.load();
        game = this;
    }

    @Override
    public void dispose() {
        Assets.dispose();
    }

    @Override
    public void render() {
        float dt = Math.min(Gdx.graphics.getDeltaTime(), 1f / 30f);
        Assets.tween.update(dt);
        screen.update(dt);
        screen.render(Assets.batch);
    }

}
