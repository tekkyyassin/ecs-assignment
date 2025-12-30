import { FC, ReactNode, useEffect } from "react";
import useLocalStorageState from "use-local-storage-state";
import { v4 as uuidv4 } from "uuid";
import { LOCAL_STORAGE_KEY_WORKSPACE_LIST_MIGRATION } from "../../configs/localStorageKeys";
import { useWorkspacesContext } from "../../contexts/WorkspacesContext/context";

type Workspace = { id: string; name: string };

export interface WorkspacesMigrationProps {
  children: ReactNode;
}

const isLegacyWorkspaceList = (list: unknown[]): list is string[] =>
  list.length > 0 && typeof list[0] === "string";

const WorkspacesMigration: FC<WorkspacesMigrationProps> = ({ children }) => {
  const { workspaceList, setWorkspaceList } = useWorkspacesContext();

  const [migrated, setMigrated] = useLocalStorageState<boolean>(
    LOCAL_STORAGE_KEY_WORKSPACE_LIST_MIGRATION,
    { defaultValue: false },
  );

  useEffect(() => {
    if (migrated) return;

    try {
      // ✅ Fail-open: if there's nothing to migrate, do not block the UI
      if (!workspaceList || workspaceList.length === 0) {
        setMigrated(true);
        return;
      }

      // ✅ If legacy format (string[]), migrate once
      if (isLegacyWorkspaceList(workspaceList as unknown[])) {
        const newList: Workspace[] = (workspaceList as string[]).map(
          (name) => ({
            id: uuidv4(),
            name,
          }),
        );

        setWorkspaceList(newList);
      }

      // ✅ Either migrated or already new format: unblock UI
      setMigrated(true);
    } catch (err) {
      // ✅ Fail-open: never brick the whole app because a migration failed
      // eslint-disable-next-line no-console
      console.error("Workspaces migration failed; continuing anyway:", err);
      setMigrated(true);
    }
  }, [migrated, workspaceList, setWorkspaceList, setMigrated]);

  return migrated && children ? <>{children}</> : null;
};

export default WorkspacesMigration;
